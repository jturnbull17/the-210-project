import React, { useEffect, useMemo, useRef, useState } from 'react'
import { createRoot } from 'react-dom/client'
import { supabase, isSupabaseConfigured } from './supabaseClient'
import './styles.css'

const DEFAULT_COUNTRIES = [
  { id: 'colombia', name: 'Colombia', code: 'CO', phase: 'phase1', route_order: 1, status: 'live', summary: '' },
  { id: 'peru', name: 'Peru', code: 'PE', phase: 'phase1', route_order: 2, status: 'visited', summary: '' },
  { id: 'argentina', name: 'Argentina', code: 'AR', phase: 'phase1', route_order: 3, status: 'visited', summary: '' },
  { id: 'brazil', name: 'Brazil', code: 'BR', phase: 'phase1', route_order: 4, status: 'visited', summary: '' },
  { id: 'vietnam', name: 'Vietnam', code: 'VN', phase: 'phase2', route_order: 5, status: 'visited', summary: '' },
  { id: 'south-korea', name: 'South Korea', code: 'KR', phase: 'phase2', route_order: 6, status: 'upcoming', summary: '' },
  { id: 'japan', name: 'Japan', code: 'JP', phase: 'phase2', route_order: 7, status: 'upcoming', summary: '' },
  { id: 'hong-kong', name: 'Hong Kong', code: 'HK', phase: 'phase2', route_order: 8, status: 'upcoming', summary: '' },
  { id: 'singapore', name: 'Singapore', code: 'SG', phase: 'phase2', route_order: 9, status: 'upcoming', summary: '' }
]

const phaseLabels = { all: 'All', phase1: 'South America', phase2: 'Asia' }
const statusLabels = { upcoming: 'Upcoming', live: 'Live', visited: 'Visited', planned: 'Upcoming', active: 'Live', completed: 'Visited' }

function normaliseStatus(status) {
  if (status === 'planned') return 'upcoming'
  if (status === 'active') return 'live'
  if (status === 'completed') return 'visited'
  return status || 'upcoming'
}

function normaliseCountry(country) {
  return {
    ...country,
    id: country.id || country.slug || country.name?.toLowerCase().replaceAll(' ', '-'),
    phase: country.phase || 'phase1',
    status: normaliseStatus(country.status || (country.is_completed ? 'visited' : 'upcoming')),
    summary: country.summary || country.description || ''
  }
}

function useHashRoute() {
  const [hash, setHash] = useState(window.location.hash || '#home')
  useEffect(() => {
    const onHash = () => setHash(window.location.hash || '#home')
    window.addEventListener('hashchange', onHash)
    return () => window.removeEventListener('hashchange', onHash)
  }, [])
  return [hash.replace('#', ''), next => { window.location.hash = next }]
}

function App() {
  const [route, go] = useHashRoute()
  const [countries, setCountries] = useState(DEFAULT_COUNTRIES)
  const [locations, setLocations] = useState([])
  const [phaseFilter, setPhaseFilter] = useState('all')
  const [notice, setNotice] = useState('')
  const aiRef = useRef(null)
  const mapRef = useRef(null)

  useEffect(() => { loadData() }, [])
  useEffect(() => {
    if (!notice) return
    const timer = setTimeout(() => setNotice(''), 2800)
    return () => clearTimeout(timer)
  }, [notice])
  useEffect(() => {
    setTimeout(() => {
      if (route === 'ai' && aiRef.current) aiRef.current.scrollIntoView({ block: 'center' })
      if (route === 'map' && mapRef.current) mapRef.current.scrollIntoView({ block: 'start' })
    }, 60)
  }, [route])

  async function loadData() {
    if (!isSupabaseConfigured) return
    const { data: countryData } = await supabase.from('countries').select('*').eq('is_published', true).order('route_order', { ascending: true })
    if (countryData?.length) setCountries(countryData.map(normaliseCountry))
    const { data: locationData } = await supabase.from('locations').select('*').order('created_at', { ascending: false })
    if (locationData) setLocations(locationData)
  }

  const visibleCountries = useMemo(() => phaseFilter === 'all' ? countries : countries.filter(c => c.phase === phaseFilter), [countries, phaseFilter])
  return <>
    {notice && <div className="toast">{notice}</div>}
    <main className="shell">
      <section className="hero" id="home"><p className="eyebrow">The 210 Project</p><h1>One journey, properly organised.</h1><p className="lead">A mobile-friendly travel archive with live status, visited countries, map phases and an AI companion.</p></section>
      {(route === 'home' || route === 'archive') && <Archive countries={countries} />}
      {(route === 'home' || route === 'map') && <MapPanel refEl={mapRef} countries={visibleCountries} phaseFilter={phaseFilter} setPhaseFilter={setPhaseFilter} />}
      {(route === 'home' || route === 'ai') && <AIBox refEl={aiRef} />}
      {route === 'admin' && <Admin countries={countries} setCountries={setCountries} locations={locations} setLocations={setLocations} setNotice={setNotice} reload={loadData} />}
    </main>
    <nav className="bottom-nav"><button onClick={() => go('home')}>Home</button><button onClick={() => go('archive')}>Archive</button><button onClick={() => go('map')}>Map</button><button onClick={() => go('ai')}>AI</button><button onClick={() => go('admin')}>Admin</button></nav>
  </>
}

function Archive({ countries }) {
  return <section className="panel" id="archive"><div className="section-heading"><p className="eyebrow">Archive</p><h2>Countries</h2></div><div className="country-grid">
    {countries.map(country => <article key={country.id} className={`country-card ${country.status === 'visited' ? 'visited' : ''} ${country.status === 'upcoming' ? 'muted' : ''} ${country.status === 'live' ? 'live' : ''}`}><div className="flag-code">{country.code}</div><h3>{country.name}</h3><p>{country.summary || 'Coming soon.'}</p><span className={`pill ${country.status}`}>{statusLabels[country.status] || country.status}</span></article>)}
  </div></section>
}

function MapPanel({ refEl, countries, phaseFilter, setPhaseFilter }) {
  return <section className="panel map-panel" id="map" ref={refEl}><div className="section-heading"><p className="eyebrow">Map</p><h2>Journey phases</h2></div><div className="phase-controls">{['all', 'phase1', 'phase2'].map(phase => <button key={phase} className={phaseFilter === phase ? 'selected' : ''} onClick={() => setPhaseFilter(phase)}>{phaseLabels[phase]}</button>)}</div><div className="map-shape">{countries.map(country => <div key={country.id} className={`map-pin ${country.phase} ${country.status}`}><strong>{country.code}</strong><span>{country.name}</span></div>)}</div></section>
}

function AIBox({ refEl }) {
  return <section className="panel ai-panel" id="ai" ref={refEl}><p className="eyebrow">Ask about the journey</p><h2>AI companion</h2><div className="ai-card"><p>Ask about the journey, route, countries, highlights or blog posts.</p><input placeholder="Ask about the journey..." /></div></section>
}

function Admin({ countries, setCountries, locations, setLocations, setNotice, reload }) {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [session, setSession] = useState(null)
  const [selectedId, setSelectedId] = useState(countries[0]?.id || 'colombia')
  const [saving, setSaving] = useState(false)
  const selected = countries.find(c => c.id === selectedId) || countries[0]
  const [draft, setDraft] = useState(selected || {})
  useEffect(() => { setDraft(selected || {}) }, [selectedId, countries.length])
  useEffect(() => {
    if (!supabase) return
    supabase.auth.getSession().then(({ data }) => setSession(data.session))
    const { data: sub } = supabase.auth.onAuthStateChange((_event, s) => setSession(s))
    return () => sub.subscription.unsubscribe()
  }, [])
  async function signIn() {
    if (!supabase) return setNotice('Supabase is not configured yet.')
    const { error } = await supabase.auth.signInWithPassword({ email, password })
    setNotice(error ? error.message : 'Signed in.')
  }
  async function saveCountry() {
    setSaving(true)
    const payload = { id: draft.id, name: draft.name, code: draft.code, phase: draft.phase, status: normaliseStatus(draft.status), summary: draft.summary, is_published: true }
    if (supabase) {
      const { error } = await supabase.from('countries').upsert(payload, { onConflict: 'id' })
      if (error) { setNotice(error.message); setSaving(false); return }
    }
    setCountries(prev => prev.map(c => c.id === payload.id ? { ...c, ...payload } : c))
    setNotice('Country summary/status saved')
    setSaving(false)
    reload?.()
  }
  async function setLiveLocation(location) {
    setSaving(true)
    if (supabase) {
      await supabase.from('locations').update({ is_live: false })
      const { error } = await supabase.from('locations').update({ is_live: true }).eq('id', location.id)
      if (error) { setNotice(error.message); setSaving(false); return }
    }
    setLocations(prev => prev.map(l => ({ ...l, is_live: l.id === location.id })))
    setNotice(`Live location updated: ${location.title || location.name || location.id}`)
    setSaving(false)
  }
  if (!session) return <section className="panel admin-panel"><p className="eyebrow">Admin</p><h2>Sign in</h2><input value={email} onChange={e => setEmail(e.target.value)} placeholder="Email" /><input value={password} onChange={e => setPassword(e.target.value)} type="password" placeholder="Password" /><button onClick={signIn}>Log in</button></section>
  return <section className="panel admin-panel"><p className="eyebrow">Admin</p><h2>Country status and map phases</h2><label>Country<select value={selectedId} onChange={e => setSelectedId(e.target.value)}>{countries.map(c => <option key={c.id} value={c.id}>{c.name}</option>)}</select></label><label>Name<input value={draft.name || ''} onChange={e => setDraft({ ...draft, name: e.target.value })} /></label><label>Code<input value={draft.code || ''} onChange={e => setDraft({ ...draft, code: e.target.value })} /></label><label>Map phase<select value={draft.phase || 'phase1'} onChange={e => setDraft({ ...draft, phase: e.target.value })}><option value="phase1">South America</option><option value="phase2">Asia</option></select></label><label>Status<select value={draft.status || 'upcoming'} onChange={e => setDraft({ ...draft, status: e.target.value })}><option value="upcoming">Upcoming</option><option value="live">Live</option><option value="visited">Visited</option></select></label><label>Summary<textarea value={draft.summary || ''} onChange={e => setDraft({ ...draft, summary: e.target.value })} /></label><button disabled={saving} onClick={saveCountry}>{saving ? 'Saving...' : 'Save country summary/status'}</button><h3>Set live location</h3><div className="live-list">{locations.length === 0 && <p>No locations found yet.</p>}{locations.map(l => <button key={l.id} disabled={saving} className={l.is_live ? 'selected' : ''} onClick={() => setLiveLocation(l)}>{l.title || l.name || l.id}</button>)}</div></section>
}

createRoot(document.getElementById('root')).render(<App />)

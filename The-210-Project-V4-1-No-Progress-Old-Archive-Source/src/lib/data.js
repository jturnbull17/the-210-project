import { supabase, hasSupabase } from './supabase';
import { fallbackCountries, fallbackLocations, fallbackSettings } from './fallback';

export async function loadPublicData(){
  if(!hasSupabase) return { countries:fallbackCountries, locations:fallbackLocations, settings:fallbackSettings, usingFallback:true };
  const [{data:countries,error:cErr},{data:locations,error:lErr},{data:settingsRows,error:sErr}] = await Promise.all([
    supabase.from('countries').select('*').eq('is_published',true).order('route_order'),
    supabase.from('locations').select('*').eq('is_published',true).order('sort_order'),
    supabase.from('site_settings').select('*').eq('id','main').limit(1)
  ]);
  if(cErr || lErr || sErr) {
    console.warn('Using fallback data due to Supabase error', cErr || lErr || sErr);
    return { countries:fallbackCountries, locations:fallbackLocations, settings:fallbackSettings, usingFallback:true };
  }
  return { countries:countries?.length?countries:fallbackCountries, locations:locations||[], settings:settingsRows?.[0]||fallbackSettings, usingFallback:false };
}

export async function updateCountry(country){
  if(!hasSupabase) throw new Error('Supabase is not configured');
  return supabase.from('countries').upsert(country).select().single();
}
export async function addLocation(location){
  if(!hasSupabase) throw new Error('Supabase is not configured');
  return supabase.from('locations').insert(location).select().single();
}
export async function updateSettings(settings){
  if(!hasSupabase) throw new Error('Supabase is not configured');
  return supabase.from('site_settings').upsert({id:'main',...settings,updated_at:new Date().toISOString()}).select().single();
}

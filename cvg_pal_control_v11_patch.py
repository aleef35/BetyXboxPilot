from pathlib import Path

root=Path("CVG_Pal_Control_Android_Source")
base=root/"app/src/main/java/br/com/corvogames/palcontrol"
p=base/"GameGridFiles.java"
s=p.read_text(encoding="utf-8")
old='public void checkKey() throws Exception { request("GET","/account/keys/current",null); }'
new=r"""public void checkKey() throws Exception { resolveServerId(); }

    // The Windows instance folder number is NOT necessarily the public API server id.
    // Find the real API id using the same GET /servers flow as CVG GameGrid Android.
    private String resolvedServerId;
    private String resolveServerId() throws Exception {
        if (resolvedServerId != null) return resolvedServerId;
        JSONObject list=request("GET","/servers",null);
        org.json.JSONArray entries=list.optJSONArray("data");
        if(entries==null) {
            JSONObject nested=list.optJSONObject("data");
            if(nested!=null) entries=nested.optJSONArray("items");
        }
        if(entries==null) entries=list.optJSONArray("servers");
        if(entries==null || entries.length()==0)
            throw new Failure(0,"Nenhum servidor acessível pela chave GameGrid (servers:read).");
        String exact=null, cvgPal=null, cvgAny=null, only=null;
        int countValid=0, countCvgPal=0, countCvg=0;
        for(int i=0;i<entries.length();i++) {
            JSONObject obj=entries.optJSONObject(i);
            if(obj==null)continue;
            String id=obj.optString("id","").trim();
            if(!id.matches("[A-Za-z0-9_-]{1,150}"))continue;
            countValid++; only=id;
            if(id.equals(SERVER)) exact=id;
            String name=obj.optString("name","").toLowerCase(java.util.Locale.ROOT);
            String game=obj.optString("game","")+" "+obj.optString("gameId","")+" "+
                obj.optString("game_slug","")+" "+obj.optString("game_name","");
            JSONObject nestedGame=obj.optJSONObject("game");
            if(nestedGame!=null) game+=" "+nestedGame.optString("name","")+" "+nestedGame.optString("id","");
            game=game.toLowerCase(java.util.Locale.ROOT);
            boolean hasCvg=name.contains("cvg") || name.contains("corvo games");
            boolean isPal=name.contains("palworld") || game.contains("palworld") || game.contains("pal_world");
            if(hasCvg) {countCvg++; cvgAny=id;}
            if(hasCvg && isPal) {countCvgPal++; cvgPal=id;}
        }
        String found=exact!=null?exact:
          countCvgPal==1?cvgPal:
          countCvg==1?cvgAny:
          countValid==1?only:null;
        if(found==null)
            throw new Failure(0,"Há vários servidores. Não foi possível identificar unicamente o Palworld CVG na API.");
        resolvedServerId=found;
        return found;
    }"""
assert old in s
s=s.replace(old,new)
assert s.count("+SERVER+")==2
s=s.replace("+SERVER+","+resolveServerId()+")
assert '"/files/content?path="' in s and 'request("PUT",' in s
p.write_text(s,encoding="utf-8")

p=base/"MainActivity.java"
s=p.read_text(encoding="utf-8")
old='if(!current.optBoolean("active",false) || !current.optBoolean("attack_supported",false)) return false;'
assert old in s
s=s.replace(old,'if(!current.optBoolean("active",false)) return false;')
old='return !needsArmed || current.optBoolean("armed",false);'
assert old in s
s=s.replace(old,'return !needsArmed || (current.optBoolean("attack_supported",false) && current.optBoolean("armed",false));')
assert 'boolean active=!busy&&eligible(false);' in s
s=s.replace('boolean active=!busy&&eligible(false);','boolean active=!busy&&eligible(false);\n        boolean supported=active&&current.optBoolean("attack_supported",false);')
s=s.replace('if(check!=null)check.setEnabled(active);','if(check!=null)check.setEnabled(supported);')
s=s.replace('if(arm!=null){arm.setEnabled(active);','if(arm!=null){arm.setEnabled(supported);')
s=s.replace('if(!eligible(false))return;','if(!eligible(false) || !current.optBoolean("attack_supported",false))return;')
assert 'if(!eligible(isAttack) || busy)' in s
s=s.replace('if(!eligible(isAttack) || busy) {setStatus("Comando bloqueado: sessão não confirmada.");return;}',
 '''if(!eligible(isAttack) || busy ||
            (!"MOBILERETURN".equals(action) && !current.optBoolean("attack_supported",false))) {
            setStatus("Comando bloqueado: sessão/ataque não confirmados.");return;
        }''')
s=s.replace('text("CVG  •  PAL CONTROL",24,true)','text("CVG  •  PAL CONTROL 1.1",24,true)')
p.write_text(s,encoding="utf-8")

p=root/"app/build.gradle"
s=p.read_text(encoding="utf-8")
assert "applicationId 'br.com.corvogames.palcontrol'" in s
s=s.replace("applicationId 'br.com.corvogames.palcontrol'","applicationId 'br.com.corvogames.palcontrol.v11'")
s=s.replace("versionCode 1","versionCode 2").replace("versionName '1.0-experimental'","versionName '1.1-API-DYNAMIC'")
p.write_text(s,encoding="utf-8")
p=root/"app/src/main/AndroidManifest.xml"
s=p.read_text(encoding="utf-8")
assert 'android:label="CVG Pal Control"' in s
s=s.replace('android:label="CVG Pal Control"','android:label="CVG Pal Control v1.1"')
s=s.replace('android:name=".MainActivity"','android:name="br.com.corvogames.palcontrol.MainActivity"')
p.write_text(s,encoding="utf-8")
print("Patched CVG Pal Control v1.1: dynamic server ID, minimal scopes, return button, independent package")
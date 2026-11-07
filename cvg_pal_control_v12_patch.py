from pathlib import Path
root=Path("CVG_Pal_Control_Android_Source")
base=root/"app/src/main/java/br/com/corvogames/palcontrol"
p=base/"MainActivity.java"
s=p.read_text(encoding="utf-8")
def replace_once(old,new):
 global s
 assert s.count(old)==1,(old[:90],s.count(old))
 s=s.replace(old,new)
replace_once('private TextView palName, skillLabel, status, details;',
             'private TextView palName, skillLabel, status, details, targetInfo;')
replace_once('private Button connect, refresh, arm, attack, check, returnHuman;',
             'private Button connect, refresh, arm, attack, check, returnHuman, targetButton;')
replace_once('text("CVG  •  PAL CONTROL 1.1",24,true)', 'text("CVG  •  PAL CONTROL 1.2",24,true)')
replace_once('refresh.setOnClickListener(v->refreshState(true));',
'''refresh.setOnClickListener(v->refreshState(true));
        targetInfo=text("ALVO: nenhum inimigo marcado",14,true);palPanel.addView(targetInfo);
        targetButton=button("ALVO — FIXAR INIMIGO");palPanel.addView(targetButton);
        targetButton.setOnClickListener(v->{
            boolean locked=current!=null&&current.optBoolean("target_locked",false);
            send(locked?"MOBILETARGETCLEAR":"MOBILETARGETLOCK",false);
        });''')
replace_once('                setStatus("Mod: "+state.optString("last_result","estado recebido"));',
'''                if(state.optBoolean("target_locked",false)){
                    String label=state.optString("target_name","Inimigo");
                    int meters=state.optInt("target_distance_m",0);
                    targetInfo.setText("ALVO FIXADO: "+label+" ("+meters+" m)");
                } else {
                    targetInfo.setText("ALVO: nenhum inimigo marcado");
                }
                setStatus("Mod: "+state.optString("last_result","estado recebido"));''')
replace_once('        if(check!=null)check.setEnabled(supported);',
'''        if(check!=null)check.setEnabled(supported);
        if(targetButton!=null){
            targetButton.setEnabled(active);
            boolean locked=current!=null&&current.optBoolean("target_locked",false);
            targetButton.setText(locked?"ALVO — DESMARCAR":"ALVO — FIXAR INIMIGO");
        }''')
replace_once('(!"MOBILERETURN".equals(action) && !current.optBoolean("attack_supported",false))',
             '(!"MOBILERETURN".equals(action) && !action.startsWith("MOBILETARGET") && !current.optBoolean("attack_supported",false))')
replace_once('                if(isAttack)lastAttackAt=System.currentTimeMillis();',
'''                if(isAttack)lastAttackAt=System.currentTimeMillis();
                if(action.startsWith("MOBILETARGET"))refreshState(true);''')
p.write_text(s,encoding="utf-8")
p=root/"app/build.gradle"
s=p.read_text(encoding="utf-8")
assert "applicationId 'br.com.corvogames.palcontrol.v11'" in s
s=s.replace("applicationId 'br.com.corvogames.palcontrol.v11'",
            "applicationId 'br.com.corvogames.palcontrol.v12'")
s=s.replace("versionCode 2","versionCode 3").replace("versionName '1.1-API-DYNAMIC'","versionName '1.2-ALVO-LOCK'")
p.write_text(s,encoding="utf-8")
p=root/"app/src/main/AndroidManifest.xml"
s=p.read_text(encoding="utf-8")
assert 'android:label="CVG Pal Control v1.1"' in s
p.write_text(s.replace('android:label="CVG Pal Control v1.1"',
                       'android:label="CVG Pal Control v1.2"'),encoding="utf-8")
print("CVG Pal Control v1.2 patched: TARGETLOCK/TARGETCLEAR, new application ID")

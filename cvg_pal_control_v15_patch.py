from pathlib import Path
root=Path('CVG_Pal_Control_Android_Source')
java=root/'app/src/main/java/br/com/corvogames/palcontrol'

def once(s,old,new):
    assert s.count(old)==1,(old[:110],s.count(old))
    return s.replace(old,new)
p=java/'GameGridFiles.java'
s=p.read_text(encoding='utf-8')
s=once(s,'MOBILE(ARM|DISARM|CHECK|ATTACK|RETURN|TARGETLOCK|TARGETCLEAR)',
    'MOBILE(ARM|DISARM|CHECK|ATTACK[23]?|RETURN|TARGETLOCK|TARGETCLEAR)')
p.write_text(s,encoding='utf-8')

p=java/'MainActivity.java'
s=p.read_text(encoding='utf-8')
s=once(s,'private Button possessPal, possessNpc, cvgSpectate, camPal, camNpc;',
       'private Button possessPal, possessNpc, cvgSpectate, camPal, camNpc, attack2, attack3;')
s=once(s,'text("CVG  •  PAL CONTROL 1.4",24,true)',
       'text("CVG  •  PAL CONTROL 1.5",24,true)')
s=once(s,'        attack.setOnClickListener(v->send("MOBILEATTACK",true));',
'''        attack.setText("ATAQUE BASICO 1 — PAL / NPC");
        attack.setOnClickListener(v->send("MOBILEATTACK",true));
        attack2=button("ATAQUE BASICO 2 — PAL");actions.addView(attack2);
        attack2.setOnClickListener(v->send("MOBILEATTACK2",true));
        attack3=button("ATAQUE BASICO 3 — PAL");actions.addView(attack3);
        attack3.setOnClickListener(v->send("MOBILEATTACK3",true));
        actions.addView(text("Ataques 2/3 usam somente habilidades encontradas no proprio Pal; nao equipam nem inventam golpes. Se faltar uma classe nativa, o servidor bloqueia.",12,false));''')
s=once(s,'        if(attack!=null)attack.setEnabled(!busy&&eligible(true));',
'''        if(attack!=null)attack.setEnabled(!busy&&eligible(true));
        boolean palSelected=current!=null&&"PAL".equals(current.optString("target_kind",""));
        int possible=current!=null?current.optInt("attack_candidate_count",0):0;
        if(attack2!=null)attack2.setEnabled(!busy&&eligible(true)&&palSelected&&possible>=2);
        if(attack3!=null)attack3.setEnabled(!busy&&eligible(true)&&palSelected&&possible>=3);''')
p.write_text(s,encoding='utf-8')

p=root/'app/build.gradle'
s=p.read_text(encoding='utf-8')
s=once(s,"applicationId 'br.com.corvogames.palcontrol.v14'", "applicationId 'br.com.corvogames.palcontrol.v15'")
s=once(s,'versionCode 5','versionCode 6')
s=once(s,"versionName '1.4-POSSESSAO-CAMERA'", "versionName '1.5-3-ATAQUES-BASICOS'")
p.write_text(s,encoding='utf-8')
p=root/'app/src/main/AndroidManifest.xml'
s=p.read_text(encoding='utf-8')
s=once(s,'android:label="CVG Pal Control v1.4"','android:label="CVG Pal Control v1.5"')
p.write_text(s,encoding='utf-8')
print('PASS v1.5: UI 3 attacks, Android command whitelist, Pal-only additional attacks, new package ID')

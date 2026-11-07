from pathlib import Path
root=Path('CVG_Pal_Control_Android_Source')
java=root/'app/src/main/java/br/com/corvogames/palcontrol'

p=java/'GameGridFiles.java'
s=p.read_text(encoding='utf-8')
old='MOBILE(ARM|DISARM|CHECK|ATTACK|RETURN)'
new='MOBILE(ARM|DISARM|CHECK|ATTACK|RETURN|TARGETLOCK|TARGETCLEAR)'
assert s.count(old)==1, 'Missing command-validation regex in GameGridFiles'
s=s.replace(old,new)
assert s.count(new)==1
p.write_text(s,encoding='utf-8')

p=java/'MainActivity.java'
s=p.read_text(encoding='utf-8')
old='if(action.startsWith("MOBILETARGET"))refreshState(true);'
new='if(action.startsWith("MOBILETARGET"))ui.postDelayed(()->refreshState(true),1500);'
assert s.count(old)==1, 'Missing target callback in MainActivity'
s=s.replace(old,new)
assert s.count('text("CVG  •  PAL CONTROL 1.2",24,true)')==1
s=s.replace('text("CVG  •  PAL CONTROL 1.2",24,true)', 'text("CVG  •  PAL CONTROL 1.3",24,true)')
p.write_text(s,encoding='utf-8')

p=root/'app/build.gradle'
s=p.read_text(encoding='utf-8')
assert s.count("applicationId 'br.com.corvogames.palcontrol.v12'")==1
s=s.replace("applicationId 'br.com.corvogames.palcontrol.v12'", "applicationId 'br.com.corvogames.palcontrol.v13'")
assert s.count('versionCode 3')==1 and s.count("versionName '1.2-ALVO-LOCK'")==1
s=s.replace('versionCode 3','versionCode 4').replace("versionName '1.2-ALVO-LOCK'", "versionName '1.3-ALVO-COMANDO-FIX'")
p.write_text(s,encoding='utf-8')

p=root/'app/src/main/AndroidManifest.xml'
s=p.read_text(encoding='utf-8')
assert s.count('android:label="CVG Pal Control v1.2"')==1
s=s.replace('android:label="CVG Pal Control v1.2"','android:label="CVG Pal Control v1.3"')
p.write_text(s,encoding='utf-8')
print('PASS: GameGridFiles permits MOBILETARGETLOCK and MOBILETARGETCLEAR; v1.3 new app ID')

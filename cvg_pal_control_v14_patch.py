from pathlib import Path

root=Path('CVG_Pal_Control_Android_Source')
java=root/'app/src/main/java/br/com/corvogames/palcontrol'

def once(s,old,new):
    n=s.count(old)
    assert n==1,(old[:120],n)
    return s.replace(old,new)

p=java/'GameGridFiles.java'
s=p.read_text(encoding='utf-8')
# Read/write access remains confined to the same one mobile status file and one fixed command file.
s=once(s,
    'if(!text.matches("^MOBILE(ARM|DISARM|CHECK|ATTACK|RETURN|TARGETLOCK|TARGETCLEAR) [0-9]{1,8} [0-9]{10,20}$"))',
    'if(!text.matches("^(?:MOBILE(ARM|DISARM|CHECK|ATTACK|RETURN|TARGETLOCK|TARGETCLEAR) [0-9]{1,8} [0-9]{10,20}|(?:TRIAL|NPCTRIAL|CVGSPEC|CVGSPECEND|CAMPAL|CAMNPC) [0-9]{1,8})$"))')
p.write_text(s,encoding='utf-8')

p=java/'MainActivity.java'
s=p.read_text(encoding='utf-8')
s=once(s,
  'private Button connect, refresh, arm, attack, check, returnHuman, targetButton;',
  'private Button connect, refresh, arm, attack, check, returnHuman, targetButton;\n'
  '    private Button possessPal, possessNpc, cvgSpectate, camPal, camNpc;')
s=once(s,
  'text("CVG  •  PAL CONTROL 1.3",24,true)',
  'text("CVG  •  PAL CONTROL 1.4",24,true)')
s=once(s,
  '''        returnHuman=button("Retornar ao humano");actions.addView(returnHuman);
        returnHuman.setOnClickListener(v->send("MOBILERETURN",false));''',
  '''        actions.addView(text("POSSESSÃO E CÂMERA",14,true));
        actions.addView(text("Possuir escolhe o alvo elegível mais próximo. CAMPAL/CAMNPC dependem da câmera espectadora validada no Xbox.",12,false));
        possessPal=button("POSSUIR PAL PRÓXIMO");actions.addView(possessPal);
        possessPal.setOnClickListener(v->sendQuick("TRIAL"));
        possessNpc=button("POSSUIR NPC PRÓXIMO");actions.addView(possessNpc);
        possessNpc.setOnClickListener(v->sendQuick("NPCTRIAL"));
        cvgSpectate=button("CVG ESPECTAR");actions.addView(cvgSpectate);
        cvgSpectate.setOnClickListener(v->sendQuick("CVGSPEC"));
        camPal=button("CAMPAL — POSSUIR PAL PELA CÂMERA");actions.addView(camPal);
        camPal.setOnClickListener(v->sendQuick("CAMPAL"));
        camNpc=button("CAMNPC — POSSUIR NPC PELA CÂMERA");actions.addView(camNpc);
        camNpc.setOnClickListener(v->sendQuick("CAMNPC"));
        returnHuman=button("RETORNAR AO CORPO");actions.addView(returnHuman);
        returnHuman.setOnClickListener(v->{
            if(current!=null && current.optBoolean("active",false)) send("MOBILERETURN",false);
            else sendQuick("CVGSPECEND");
        });''')
s=once(s,
  '''        if(returnHuman!=null)returnHuman.setEnabled(active);''',
  '''        boolean readyForNew=!busy&&freshConnected()&&!current.optBoolean("active",false);
        if(possessPal!=null)possessPal.setEnabled(readyForNew);
        if(possessNpc!=null)possessNpc.setEnabled(readyForNew);
        if(cvgSpectate!=null)cvgSpectate.setEnabled(readyForNew);
        if(camPal!=null)camPal.setEnabled(readyForNew);
        if(camNpc!=null)camNpc.setEnabled(readyForNew);
        if(returnHuman!=null)returnHuman.setEnabled(active||readyForNew);''')
needle='    private void confirmArm(){'
addition='''    /** Live status is required, including when no Pal is currently possessed. */
    private boolean freshConnected(){
        if(key==null || current==null)return false;
        long last=current.optLong("updated_unix",0L);
        long age=Math.abs(System.currentTimeMillis()/1000L-last);
        return last>0 && age<=45;
    }
    /** Five trusted v32 private-file commands, without a possession token.
     * No retries, auto-possession, or uncontrolled command text input. */
    private void sendQuick(String action){
        if(!("TRIAL".equals(action)||"NPCTRIAL".equals(action)
          ||"CVGSPEC".equals(action)||"CVGSPECEND".equals(action)
          ||"CAMPAL".equals(action)||"CAMNPC".equals(action))){
            setStatus("Ação desconhecida; envio bloqueado.");return;
        }
        if(busy||!freshConnected()||current.optBoolean("active",false)){
            setStatus("Atualize o estado e retorne ao humano antes desta ação.");return;
        }
        final int sequence=nextSequence;
        if(sequence<1||sequence>99999998){setStatus("Sequência de comandos esgotada.");return;}
        final String cmd=action+" "+sequence;
        final String token=key;
        runNetwork("Solicitando "+action+"…",()->{
            new GameGridFiles(token).writeCommand(cmd);
            ui.post(()->{
                nextSequence=sequence+1;
                getPreferences(MODE_PRIVATE).edit().putInt("local_seq",nextSequence).apply();
                String note="Comando "+action+" enviado; confirme o resultado no Xbox e no log.";
                if("CVGSPEC".equals(action))note="CVG Espectar solicitado: mova a câmera pelo menos 1 m no Xbox antes de CAMPAL/CAMNPC.";
                setStatus(note);
                ui.postDelayed(()->refreshState(true),2200);
            });
        });
    }
'''
s=once(s,needle,addition+needle)
p.write_text(s,encoding='utf-8')

p=root/'app/build.gradle'
s=p.read_text(encoding='utf-8')
s=once(s,"applicationId 'br.com.corvogames.palcontrol.v13'","applicationId 'br.com.corvogames.palcontrol.v14'")
s=once(s,'versionCode 4','versionCode 5')
s=once(s,"versionName '1.3-ALVO-COMANDO-FIX'","versionName '1.4-POSSESSAO-CAMERA'")
p.write_text(s,encoding='utf-8')

p=root/'app/src/main/AndroidManifest.xml'
s=p.read_text(encoding='utf-8')
s=once(s,'android:label="CVG Pal Control v1.3"','android:label="CVG Pal Control v1.4"')
p.write_text(s,encoding='utf-8')

assert s.count('CVG Pal Control v1.4')==1
print('PASS: v1.4 five new buttons, existing controls preserved, v32 private commands, CVGSPECEND via Return')

from pathlib import Path
root=Path('CVG_Pal_Control_Android_Source')
java=root/'app/src/main/java/br/com/corvogames/palcontrol'
def once(s,old,new):
    n=s.count(old)
    assert n==1,(old[:125],n)
    return s.replace(old,new)

p=java/'GameGridFiles.java'
s=p.read_text(encoding='utf-8')
s=once(s,
   '|(?:TRIAL|NPCTRIAL|CVGSPEC|CVGSPECEND|CAMPAL|CAMNPC) [0-9]{1,8})$',
   '|(?:TRIAL|NPCTRIAL|CVGSPEC|CVGSPECEND|CAMPAL|CAMNPC) [0-9]{1,8}|MOBILESAY [0-9]{1,8} [0-9]{10,20} [0-9A-F]{2,240})$')
p.write_text(s,encoding='utf-8')

p=java/'MainActivity.java'
s=p.read_text(encoding='utf-8')
s=once(s,'import android.widget.*;','import android.widget.*;\nimport java.nio.charset.StandardCharsets;')
s=once(s,'private long lastAttackAt=0L;','private long lastAttackAt=0L;\n    private long lastSayAt=0L;')
s=once(s,'private EditText keyField;','private EditText keyField, sayField;')
s=once(s,'private Button possessPal, possessNpc, cvgSpectate, camPal, camNpc, attack2, attack3;',
       'private Button possessPal, possessNpc, cvgSpectate, camPal, camNpc, attack2, attack3, sendSay;')
s=once(s,'text("CVG  •  PAL CONTROL 1.5",24,true)', 'text("CVG  •  PAL CONTROL 1.6",24,true)')
needle='        status=text("Sem conexão",14,false);root.addView(status);'
addition='''        LinearLayout sayPanel=panel();root.addView(sayPanel);
        sayPanel.addView(text("FALA DO PAL — SAY",15,true));
        sayPanel.addView(text("Texto aparece com o nome do Pal possuído. Indisponível sem possessão válida de Pal.",12,false));
        sayField=new EditText(this);
        sayField.setHint("Escreva o que o Pal vai dizer...");
        sayField.setSingleLine(false);
        sayField.setMinLines(2);
        sayField.setMaxLines(4);
        sayField.setFilters(new android.text.InputFilter[]{new android.text.InputFilter.LengthFilter(120)});
        sayPanel.addView(sayField,new LinearLayout.LayoutParams(-1,dp(104)));
        sendSay=button("ENVIAR PELO SAY");
        sayPanel.addView(sendSay);
        sendSay.setOnClickListener(v->sendPalSay());
'''
s=once(s,needle,addition+needle)
needle='    private void confirmArm(){'
addition=r'''    /** Independent of attack arming. The server is authoritative about ownership. */
    private boolean sayAllowed(){
        return !busy && key!=null && current!=null
            && current.optBoolean("active",false)
            && "PAL".equals(current.optString("target_kind",""))
            && current.optBoolean("say_enabled",false)
            && current.optString("session","").matches("[0-9]{10,20}")
            && freshConnected();
    }
    private void sendPalSay(){
        if(!sayAllowed()) {setStatus("SAY bloqueado: possua um Pal e atualize o estado.");return;}
        String raw=sayField.getText().toString().trim();
        if(raw.isEmpty() || raw.startsWith("/") || raw.startsWith("!")){
            setStatus("Digite uma frase, sem comando de chat.");return;
        }
        for(int i=0;i<raw.length();i++){
            char c=raw.charAt(i);
            if(Character.isISOControl(c)) {setStatus("SAY bloqueado: caractere de controle.");return;}
        }
        byte[] bytes=raw.getBytes(StandardCharsets.UTF_8);
        if(bytes.length<1 || bytes.length>120){
            setStatus("SAY permite até 120 bytes UTF-8. Encurte o texto.");return;
        }
        if(System.currentTimeMillis()-lastSayAt<6000L){
            setStatus("Aguarde 6 segundos entre mensagens do Pal.");return;
        }
        StringBuilder hex=new StringBuilder(bytes.length*2);
        final char[] digits="0123456789ABCDEF".toCharArray();
        for(byte b:bytes){
            int v=b&0xff;
            hex.append(digits[v>>>4]);hex.append(digits[v&15]);
        }
        final int sequence=nextSequence;
        if(sequence<1||sequence>99999998){setStatus("Sequência de comandos esgotada.");return;}
        final String cmd="MOBILESAY "+sequence+" "+current.optString("session","")+" "+hex;
        final String token=key;
        runNetwork("Solicitando fala do Pal…",()->{
            new GameGridFiles(token).writeCommand(cmd);
            ui.post(()->{
                nextSequence=sequence+1;
                getPreferences(MODE_PRIVATE).edit().putInt("local_seq",nextSequence).apply();
                lastSayAt=System.currentTimeMillis();
                sayField.setText("");
                setStatus("SAY solicitado. Confirme a mensagem no Xbox e no log.");
                ui.postDelayed(()->refreshState(true),1100);
            });
        });
    }
'''
s=once(s,needle,addition+needle)
needle='        if(returnHuman!=null)returnHuman.setEnabled(active||readyForNew);'
s=once(s,needle,needle+'''
        boolean sayReady=sayAllowed();
        if(sayField!=null)sayField.setEnabled(sayReady);
        if(sendSay!=null)sendSay.setEnabled(sayReady);''')
p.write_text(s,encoding='utf-8')
p=root/'app/build.gradle'
s=p.read_text(encoding='utf-8')
s=once(s,"applicationId 'br.com.corvogames.palcontrol.v15'","applicationId 'br.com.corvogames.palcontrol.v16'")
s=once(s,'versionCode 6','versionCode 7')
s=once(s,"versionName '1.5-3-ATAQUES-BASICOS'","versionName '1.6-PAL-SAY-MIRA'")
p.write_text(s,encoding='utf-8')
p=root/'app/src/main/AndroidManifest.xml'
s=p.read_text(encoding='utf-8')
s=once(s,'android:label="CVG Pal Control v1.5"','android:label="CVG Pal Control v1.6"')
p.write_text(s,encoding='utf-8')
print('PASS v1.6: private hexadecimal SAY command; strict Pal possession; UI disabled on no possession/NPC; 6s cooldown; 120 UTF8 bytes; new app ID')

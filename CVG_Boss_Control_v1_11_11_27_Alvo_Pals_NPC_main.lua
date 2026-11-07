-- CVG v1.11.11.27: alvo travado manual 35m/60m + ataque direcionado por giro horizontal de ator, sob verificacao.
-- Retem limpeza de Pal morto v20, Paldium Cannon 342 v19, 3 pulos/RETURN.
-- Xbox demora a digitar CAMPAL: TTL do ultimo RPC autenticado estendido a 45s.
-- SEM ignorar identidade/autoridade, sem adquirir reticulo do cliente, sem segundo EndSpectate.
-- Nao ha garantia de sucesso em Xbox; somente clone isolado com backup.
-- CVG v1.11.11.20 clone: morto o Pal selvagem exato possuido, retornar humano e tentar
-- remover APENAS seu ator morto apos seguranca/recompensas; evento GYM/raid/tower protegido.
-- K2_DestroyActor e NATIVO e pode causar queda: NAO instalar diretamente em producao.
-- CVG v1.11.11.23 MOBILE BRIDGE FIX: qualified status JSON encoder and file path;
-- CVG v1.11.11.19 clone: Astralym Paldium Cannon laser ID342 no BASEATTACK/esquiva; 20s recarga; demais Pals inalterados.
-- v1.11.11.16 CLONE RT persistente: RTARM uma vez por posse; sem limite de tentativas; 8s entre ataques;
-- soltar RT antes do proximo aperto, sem loop; RTDISARM/RETURN para parar.
-- AVISO: so responde se o Xbox enviar SHOOT com shooter comprovado como Pal.
-- PlayAction nativo ainda pode derrubar o servidor; usar apenas em clone isolado com backup.
-- v1.11.11.11 CAMPAL native camera bridge: CAMARM stores authenticated
-- spectator component before /ToggleSpectate; stricter server spectator
-- diagnostics and safe allowance for verified server camera with human pawn.
-- No Xbox reticle guarantee, no bypass of camera motion, owner auth, or recovery.
-- Experimental: clone only; no auto attack or native actions added here.
-- v1.11.11.5 HANDOFF EXPERIMENTAL: protege /spectate nativo -> !cvg espectar -> !cvg campal.
-- Se ja esta no espectador nativo, NAO faz BeginSpectate outra vez.
-- Quando CVGSPEC for usado, EndSpectate e Possess nao ocorrem no mesmo instante:
-- uma unica etapa atrasada, com nova verificacao de PC/humano/Pal/AI.
-- Uma tentativa por comando, SEM limitador artificial, SEM LoopAsync/hook novos.
-- Base v1.11.11.1 + mitigacoes de leitura de skill/avisos nativos da 1.11.11.4.
-- TESTE SOMENTE EM CLONE. pcall nao intercepta EXCEPTION_ACCESS_VIOLATION.
-- v1.11.11.4: MITIGACAO DE ENTRADA, preserva a posse EXPERIMENTAL.
-- Remove leituras automaticas de skills dentro de TRIAL e avisos privados nativos;
-- nao altera captura, Possess, setup do Xbox, retorno em 3 saltos ou /spectate nativo.
-- NAO Garante evitar EXCEPTION_ACCESS_VIOLATION em funcoes nativas.
-- v1.11.11.1 (experimento seguro): preservar a sessao nativa /ToggleSpectate
-- quando a possessao comecou pelo CAMARM + /spectate do jogo (NAO CVGSPEC).
-- Apos humano ORIGINAL e journal SAFE, tenta BeginSpectate(true) 1 vez,
-- opcionalmente K2_TeleportTo SOMENTE num SpectatorPawn servidor verificado.
-- Sem mover o humano, sem novo loop, sem mexer nas funcoes de ataque.
-- A camera Xbox no local do Pal NAO pode ser garantida em dedicated server.
-- v1.11.5: recuperar interacao do humano apos sair de Pal/NPC.
-- ClientRetryClientRestart pode ignorar um pawn ja reconhecido pelo Xbox.
-- Tenta UMA reinicializacao ClientRestart(humano_original) 850ms apos retorno
-- VERIFICADO e jornal SAFE. Tem fallback manual INTERACT; nenhuma exclusao.
-- Sucesso RPC no servidor NAO comprova interacao no cliente Xbox.
-- v1.11.11: volta para base comprovada v1.11.8; NAO importa leitor de indices da
-- v1.11.9 associado a quedas no servidor. Nenhum ataque automatico na posse.
-- ATTACKVER e ATTACK1: teste isolado opcional da action nativa BP_ActionShootSkill_C,
-- nome de classe documentado em dump publico Palworld; classe pode nao estar
-- carregada ou nao funcionar para todos os Pals. Teste manual, 1 por sessao,
-- verificacoes fail-closed, nunca altera slots/equip Waza/dano/cooldown.
-- v1.11.8: WAZACHECK (array GetEquipWaza + WazaActionInstancedMap, somente leitura); WAZA1-3
-- experimento sob comando manual: classe nativa do golpe equip. -> ActionComponent:PlayAction(nil, classe).
-- Sem SetSkill, escrita de HP, alterar passivas/dano/cooldown/IA, sem automatismos.
-- A tentativa nao garante efeito visual Xbox. Classe ausente = sem chamada.
-- v1.11.7: diagnostico SOMENTE LEITURA de skills equipadas no actor e ActionComponent do Pal,
-- comparacao antes/depois da posse e tratamento correto de PlaySkill=false (rejeitado).
-- v1.11.4: teste controlado de SKILL1/2/3 usando PlaySkill existente.
-- NEW: captura snapshots read-only do cooldown e da acao do MESMO Pal nos
-- 250ms e 1100ms apos comando, para distinguir chamada de inicio de ataque.
-- Sem alteracao de EquipWaza, dano, captura, cooldown ou IA; sem spam automatico.
-- Ataque do Xbox permanece EXPERIMENTAL e nao e controle direto por botao.
-- v1.11.3: reentrada automatica apos retorno humano verificado; journal/ghost/AI
-- antigos NAO criam trava permanente em novas TRIAL; sem destruicao de jogador.
-- Sem posse enquanto dono nao tem pawn humano comprovado; nenhuma outra conta controlada.
-- v1.11.2: mira da camera por ROTACAO do RPC nativo Xbox, quando legivel.
-- Sem rotacao atestada, fallback seguro da selecao por distancia da v1.11.1.
-- Alerta de possivel streaming remoto e SAFEON opcional para retorno preventivo.
-- Nao fornece raytrace/reticulo real nem corrige world streaming do Xbox.
-- v1.11.1: corrige readback de floats de rede sem relaxar identidade nativa; diagnostico de cada condicao da verificacao.
-- v1.11.0: reforco de relevancia de rede por ator Pal/NPC, distancia 3D, pulso controlado;
-- testes do Xbox de streaming/combate ainda pendentes; nao altera mundo nem outros atores.
-- v1.10.9: modo CVGSPECTATE via PalPlayerController:BeginSpectate(true).
-- Observa RPC nativo SERVER do componente Spectate:ServerSyncSpectatorLocation.
-- Camera servidor agora decorre de RPC do admin, nao do SpectatorPawn local Xbox.
-- Um comando CAMPAL/CAMNPC seleciona por proximidade somente se o RPC
-- for fresco, mudou pelo menos 1m e humano original permanece valido.
-- Antes do Possess, EndSpectate() e retorno ao humano ORIGINAL verificados.
-- Sem RPC verificado o novo modo nao permite Possess; nao move avatar nem saves.
-- Esta ponte nao esta validada ainda em Xbox: testar em ambiente controlado.
-- v1.10.8: servidor spectator camera origin, manual NPC/Pal, fail-closed.
-- CVG Boss Control v1.10.8 — BOSS MODE: DIAGNOSTICO SEM ALTERAR PALS / WILD TRIAL ATIVO; SAIDA MANUAL; XBOX EXPERIMENTAL.
-- CVG Boss Control v1.10.0 — ONE WILD PAL ACTION COMPOSITE REBIND (EXPERIMENTAL).
-- Depois de devolver o jogador humano, verificar que o MESMO controlador Wild
-- retoma o MESMO Pal e, se IsActiveAI mudou de true para false, reativar
-- somente esse controlador com um SetActiveAI(true) e revalidar em 900ms.
-- Se identidade nao puder ser confirmada, bloquear novos TRIAL nesta sessao.
-- NUNCA criar controller substituto, mexer em outros Pals ou fazer world scan.
-- RESYNC: um unico ClientRestart(Pal) RPC ao proprio controller do dono;
-- nao modifica coords, nao chama Possess, nao mexe em outras entidades.
-- OBS: UFUNCTION pode nao estar disponivel; chamada Lua bem-sucedida nao comprova entrega Xbox.
-- Resync automatico unico aos 55m continua EXPERIMENTAL, pode afetar inputs do Xbox do admin.
-- AVISO: TRIAL MUDA CONTROLLER/Pawn; COM OUTROS JOGADORES O RISCO DE INTERACAO/CRASH E MAIOR.
-- Possess pode derrubar o processo nativo apesar do pcall; timer nao protege crash.
-- SERVIDOR WDC GAMEGRID / XBOX: barra '/' e interpretada no cliente.
-- Nao ha API comprovada para criar /cvgteste privadamente no cliente Xbox.
-- TRIAL: sem limite por boot; so repete apos retorno verificado e journal SAFE.
-- CHECK: preflight seguro e repetivel, sem transferencia de corpo.
-- v1.4: TRIAL faz todas verificacoes no proprio comando, sem CHECK previo.
-- Erro yaw/pitch e registrado somente como DIAGNOSTICO, nao e gate.
-- CHECK permanece diagnostico opcional e NAO arma nem autoriza TRIAL.
-- Nao le pixels nem marcacao do reticulo Xbox; prioriza proximidade com separacao segura.
-- A amostra nao e exaustiva: bloquear se FindObjects atingir o limite; sem garantia de alvo marcado.
-- TRIAL seleciona Pal Wild MAIS PROXIMO ate 30m, apenas com vantagem clara sobre o segundo.
-- v1.10.0: sem timer de duracao; RETURN TXT ou 3 pulos. Perigo/logout tentam resgate.
-- Agendamento e best-effort; timer nao sobrevive a crash ou queda do servidor.
-- v1.8.6: eventos de morte e captura TENTAM devolver humano; sem garantia de chegada a tempo.
-- Remocao de copia apenas por comando MANUAL e quando identificada por referencia da sessao.
-- NAO faz spawn, dano ou edicao de saves; eventos do jogo podem modificar estado.
-- VIEW le apenas a rotacao do controller ADMIN validado no game thread.
-- AIM calcula vetor geometrico sem chamar funcoes de NPCs.
-- ORIGIN le K2_GetPawn/K2_GetActorLocation APENAS do proprio jogador.
-- NEAR amostra no maximo 128 PalCharacter usando FindObjects, sob demanda.
-- Teste NEAR pode ser custoso; NUNCA disparar automaticamente ou em loop.
-- TRIAL muda temporariamente o pawn do proprietario; NEAR continua somente leitura.
-- NEAR nao e identificacao de alvo do reticulo; visao e geometria aproximadas.
-- GetControlRotation nao esta validado no Xbox; execute VIEW 1x e veja o log.
-- NUNCA registrar senhas, conteudo de chat ou identificadores de jogadores.
-- O Xbox nao expõe ao UE4SS dedicado o botao de ataque do Pal possuido; ponte experimental via chat/TXT.
-- O journal ACTIVE sobrevive a crash/boot e bloqueia novo TRIAL ate verificacao manual.
-- Possession e recovery usam UObject nativo; IsValid/pcall NAO garantem seguranca.
local VERSION = '1.11.11.27-308PALS-NPC-ALVO-MANUAL-CLONE'
local CVG_NATIVE_POSSESSION_ENABLED=true -- constante por perfil, nao alteravel por chat
local CVG_DISABLE_PRIVATE_NATIVE_NOTICES=true -- os avisos antigos gerais continuam bloqueados: risco nativo conhecido
local CVG_ASTRALYM_SHOT_NATIVE_ENABLED=true -- no native cast in public diagnostic profile -- aviso de log somente UE4SS.log; sem RPC PalUtility
-- v1.10.6: comandos NPC humano explicitamente disponiveis via chat:
-- !cvg npcver (diagnostico) e !cvg npc (possessao). Alias antigos
-- !cvg npccheck / !cvg npctrial mantidos. TXT NPCVER / NPC tambem.
-- NUNCA selecionar player nem Pal: classe PalNPC, IsPal=false e
-- nao PalMonsterCharacter, alvo vivo, autoridade e AI original elegivel.
-- A selecao segue fail-closed em alvos ambiguos, sem marcar NPC do reticulo.
-- O chat nao abre durante a possessao no Xbox: volta por 3 pulos ou TXT RETURN.
-- Protecao temporaria de captura anterior permanece SOMENTE no Pal selvagem.

-- v1.10.5: somente o PAL selvagem EXATO possuido fica temporariamente incapturavel.
-- Snapshots dos 3 flags, aplicacao antes do Possess, confirmacao por readback,
-- restauracao exata ao humano confirmado; falhar fechado se faltar API/identidade.
-- ATENCAO: flags no servidor nao garantem imunidade 100% em todas as esferas,
-- crash/reconnect e chamadas nativas nao sao cobertos por verificacao so em Lua.
-- v1.10.4: recuperacao das acoes padrao do controller original apos SetActiveAI.
-- Metodos Blueprint especificos: Wild=PlayDefaultAction; NPC=StartDefaultAIAction.
-- Executar NO MAXIMO uma vez, depois de confirmar humano + NPC/Pal + AI + componente originais.
-- Metodos podem nao existir nesta versao do jogo: falhar fechado, manter quarentena.
-- Ataques diretos continuam experimentais: PlaySkill retornou false em Xbox (28/10/2026).
-- v1.10.3: ataque experimental por chat/TXT, apenas Pal selvagem possuido pelo proprio admin.
-- PlaySkill(0..2) nativo: retorno true significa aceito, nao prova animacao/dano no Xbox.
-- Nao altera Waza/equipamento, IA, cooldowns ou dano; sem disparos automaticos.
-- v1.10.2: tentativa de reativacao ONE-SHOT do AI original apos verificar NPC travado; multiplayer preservado.
local LEGACY_WILD_TRIAL_ENABLED=true
local pal_control={}
-- Identidade exata de especie no GetCharacterID; enum IDs locais,
-- NUNCA tentar um golpe de especie diferente nem fallback generico.
-- O enum e catalogo; a classe real deve existir no WazaActionInstancedMap
-- do exato Pal possuido e ser validada na hora do comando.
pal_control.base_attack_profiles={
    SheepBall={name='Lamball',skill='Roly Poly',waza=18},
    ChickenPal={name='Chikipi',skill='Chicken Peck',waza=19},
    PinkCat={name='Cattiva',skill='Cat Punch',waza=16},
    Garm={name='Direhowl',skill='Bite',waza=13},
    Boar={name='Rushoar',skill='Tackle',waza=15},
    -- Astralym: laser grande disparado do peito/anel = Paldium Cannon (ID342).
    -- Nao usar Shot ID341 (multiplos projeteis), nem LaserGliding ID349 (fase voadora).
    -- Para cada variante, exige a classe ID342 no WazaActionInstancedMap do exato Pal.
    WorldTreeDragon={name='Astralym',skill='Paldium Cannon (laser)',waza=342,cooldown=20},
    BOSS_WorldTreeDragon={name='Astralym Boss',skill='Paldium Cannon (laser)',waza=342,cooldown=20},
    GYM_WorldTreeDragon={name='Astralym',skill='Paldium Cannon (laser)',waza=342,cooldown=20},
    GYM_WorldTreeDragon_2={name='Astralym HARD+',skill='Paldium Cannon (laser)',waza=342,cooldown=20},
}
-- CVG v1.11.11.26: named Pal species & NPC firearm-first basic attack candidates.
-- Offline identification only. NO skill grant, damage write, new guns, or other actor changes.
pal_control.basic_species_catalog={
    ['BadCatgirl']={'Nyafia','Dark',''},
    ['BlueberryFairy']={'Prunelia','Leaf','Dark'},
    ['BrownRabbit']={'Lapiron','Earth',''},
    ['ElecLion']={'Boltmane','Electricity',''},
    ['GoldenHorse']={'Gildane','Earth',''},
    ['TentacleTurtle']={'Turtacle','Water',''},
    ['TentacleTurtle_Ground']={'Turtacle Terra','Water','Earth'},
    ['Anubis']={'Anubis','Earth',''},
    ['Baphomet']={'Incineram','Fire','Dark'},
    ['Baphomet_Dark']={'Incineram Noct','Dark',''},
    ['Bastet']={'Mau','Dark',''},
    ['Bastet_Ice']={'Mau Cryst','Ice',''},
    ['Boar']={'Rushoar','Earth',''},
    ['Carbunclo']={'Lifmunk','Leaf',''},
    ['ColorfulBird']={'Tocotoco','Normal',''},
    ['Deer']={'Eikthyrdeer','Normal',''},
    ['Deer_Ground']={'Eikthyrdeer Terra','Earth',''},
    ['DrillGame']={'Digtoise','Earth',''},
    ['Eagle']={'Galeclaw','Normal',''},
    ['ElecPanda']={'Grizzbolt','Electricity',''},
    ['Ganesha']={'Teafant','Water',''},
    ['Garm']={'Direhowl','Normal',''},
    ['Gorilla']={'Gorirat','Normal',''},
    ['Gorilla_Ground']={'Gorirat Terra','Earth',''},
    ['Hedgehog']={'Jolthog','Electricity',''},
    ['Hedgehog_Ice']={'Jolthog Cryst','Ice',''},
    ['Kirin']={'Univolt','Electricity',''},
    ['Kirin_Ice']={'Univolt Cryst','Ice',''},
    ['Kitsunebi']={'Foxparks','Fire',''},
    ['LittleBriarRose']={'Bristla','Leaf',''},
    ['Mutant']={'Lunaris','Normal',''},
    ['Penguin']={'Pengullet','Water','Ice'},
    ['Penguin_Electric']={'Pengullet Lux','Water','Electricity'},
    ['RaijinDaughter']={'Dazzi','Electricity',''},
    ['SharkKid']={'Gobfin','Water',''},
    ['SharkKid_Fire']={'Gobfin Ignis','Fire',''},
    ['SheepBall']={'Lamball','Normal',''},
    ['Umihebi']={'Jormuntide','Dragon','Water'},
    ['Umihebi_Fire']={'Jormuntide Ignis','Dragon','Fire'},
    ['Werewolf']={'Loupmoon','Dark',''},
    ['WindChimes']={'Hangyu','Earth',''},
    ['WindChimes_Ice']={'Hangyu Cryst','Ice',''},
    ['Suzaku']={'Suzaku','Fire',''},
    ['Suzaku_Water']={'Suzaku Aqua','Water',''},
    ['FireKirin']={'Pyrin','Fire',''},
    ['FireKirin_Dark']={'Pyrin Noct','Fire','Dark'},
    ['FairyDragon']={'Elphidran','Dragon',''},
    ['FairyDragon_Water']={'Elphidran Aqua','Dragon','Water'},
    ['SweetsSheep']={'Woolipop','Normal',''},
    ['SweetsSheep_Ground']={'Woolipop Terra','Earth',''},
    ['WhiteTiger']={'Cryolinx','Ice',''},
    ['Alpaca']={'Melpaca','Normal',''},
    ['Serpent']={'Surfent','Water',''},
    ['Serpent_Ground']={'Surfent Terra','Earth',''},
    ['DarkCrow']={'Cawgnito','Dark',''},
    ['BlueDragon']={'Azurobe','Water','Dragon'},
    ['BlueDragon_Ice']={'Azurobe Cryst','Ice','Dragon'},
    ['PinkCat']={'Cattiva','Normal',''},
    ['NegativeKoala']={'Depresso','Dark',''},
    ['FengyunDeeper']={'Fenglope','Normal',''},
    ['VolcanicMonster']={'Reptyro','Fire','Earth'},
    ['VolcanicMonster_Ice']={'Reptyro Cryst','Ice','Earth'},
    ['GhostBeast']={'Maraith','Dark',''},
    ['RobinHood']={'Robinquill','Leaf',''},
    ['RobinHood_Ground']={'Robinquill Terra','Leaf','Earth'},
    ['LazyDragon']={'Relaxaurus','Dragon','Water'},
    ['LazyDragon_Electric']={'Relaxaurus Lux','Dragon','Electricity'},
    ['AmaterasuWolf']={'Kitsun','Fire',''},
    ['LizardMan']={'Leezpunk','Dark',''},
    ['LizardMan_Fire']={'Leezpunk Ignis','Fire',''},
    ['BluePlatypus']={'Fuack','Water',''},
    ['BluePlatypus_Fire']={'Fuack Ignis','Water','Fire'},
    ['BlackFurDragon']={'Dragostrophe','Dark','Dragon'},
    ['BirdDragon']={'Vanwyrm','Fire','Dark'},
    ['BirdDragon_Ice']={'Vanwyrm Cryst','Ice','Dark'},
    ['ChickenPal']={'Chikipi','Normal',''},
    ['FlowerDinosaur']={'Dinossom','Leaf','Dragon'},
    ['FlowerDinosaur_Electric']={'Dinossom Lux','Electricity','Dragon'},
    ['ElecCat']={'Sparkit','Electricity',''},
    ['IceHorse']={'Frostallion','Ice',''},
    ['IceHorse_Dark']={'Frostallion Noct','Dark',''},
    ['GrassMammoth']={'Mammorest','Leaf','Earth'},
    ['GrassMammoth_Ice']={'Mammorest Cryst','Ice','Earth'},
    ['CatVampire']={'Felbat','Dark',''},
    ['SakuraSaurus']={'Broncherry','Leaf',''},
    ['SakuraSaurus_Water']={'Broncherry Aqua','Leaf','Water'},
    ['Horus']={'Faleris','Fire',''},
    ['KingBahamut']={'Blazamut','Fire',''},
    ['KingBahamut_Dragon']={'Blazamut Ryu','Dragon','Fire'},
    ['BerryGoat']={'Caprity','Leaf',''},
    ['IceDeer']={'Reindrix','Ice',''},
    ['BlackGriffon']={'Shadowbeak','Dark',''},
    ['WhiteMoth']={'Sibelyx','Ice',''},
    ['WhiteMoth_Neutral']={'Sibelyx Primo','Normal',''},
    ['CuteFox']={'Vixy','Normal',''},
    ['FoxMage']={'Wixen','Fire',''},
    ['FoxMage_Dark']={'Wixen Noct','Fire','Dark'},
    ['PinkLizard']={'Lovander','Dark',''},
    ['WizardOwl']={'Hoocrates','Dark',''},
    ['Kelpie']={'Kelpsea','Water',''},
    ['Kelpie_Fire']={'Kelpsea Ignis','Fire',''},
    ['NegativeOctopus']={'Killamari','Dark','Water'},
    ['NegativeOctopus_Neutral']={'Killamari Primo','Normal','Water'},
    ['CowPal']={'Mozzarina','Normal',''},
    ['Yeti']={'Wumpo','Ice',''},
    ['Yeti_Grass']={'Wumpo Botan','Leaf',''},
    ['VioletFairy']={'Vaelet','Leaf',''},
    ['HawkBird']={'Nitewing','Normal',''},
    ['FlowerRabbit']={'Flopie','Leaf',''},
    ['LilyQueen']={'Lyleen','Leaf',''},
    ['LilyQueen_Dark']={'Lyleen Noct','Dark',''},
    ['QueenBee']={'Elizabee','Leaf',''},
    ['SoldierBee']={'Beegarde','Leaf',''},
    ['CatBat']={'Tombat','Dark',''},
    ['GrassPanda']={'Mossanda','Leaf',''},
    ['GrassPanda_Electric']={'Mossanda Lux','Electricity',''},
    ['FlameBuffalo']={'Arsox','Fire',''},
    ['ThunderDog']={'Rayhound','Electricity',''},
    ['ThunderDog_Ice']={'Rayhound Cryst','Ice',''},
    ['CuteMole']={'Fuddler','Earth',''},
    ['BlackMetalDragon']={'Astegon','Dragon','Dark'},
    ['GrassRabbitMan']={'Verdash','Leaf',''},
    ['IceFox']={'Foxcicle','Ice',''},
    ['JetDragon']={'Jetragon','Dragon',''},
    ['DreamDemon']={'Daedream','Dark',''},
    ['Monkey']={'Tanzee','Leaf',''},
    ['Monkey_Ice']={'Tanzee Cryst','Ice',''},
    ['Monkey_Fire']={'Tanzee Ignis','Fire',''},
    ['Manticore']={'Blazehowl','Fire',''},
    ['Manticore_Dark']={'Blazehowl Noct','Fire','Dark'},
    ['KingAlpaca']={'Kingpaca','Normal',''},
    ['KingAlpaca_Ice']={'Kingpaca Cryst','Ice',''},
    ['PlantSlime']={'Gumoss','Leaf','Earth'},
    ['MopBaby']={'Swee','Ice',''},
    ['MopKing']={'Sweepa','Ice',''},
    ['CatMage']={'Katress','Dark',''},
    ['CatMage_Fire']={'Katress Ignis','Dark','Fire'},
    ['PinkRabbit']={'Ribbuny','Normal',''},
    ['ThunderBird']={'Beakon','Electricity',''},
    ['ThunderBird_Ice']={'Beakon Cryst','Ice',''},
    ['HerculesBeetle']={'Warsect','Earth','Leaf'},
    ['HerculesBeetle_Ground']={'Warsect Terra','Earth',''},
    ['SaintCentaur']={'Paladius','Normal',''},
    ['NightFox']={'Nox','Dark',''},
    ['CaptainPenguin']={'Penking','Water','Ice'},
    ['CaptainPenguin_Black']={'Penking Lux','Water','Electricity'},
    ['WeaselDragon']={'Chillet','Ice','Dragon'},
    ['WeaselDragon_Fire']={'Chillet Ignis','Fire','Dragon'},
    ['SkyDragon']={'Quivern','Dragon',''},
    ['SkyDragon_Grass']={'Quivern Botan','Dragon','Leaf'},
    ['HadesBird']={'Helzephyr','Dark',''},
    ['HadesBird_Electric']={'Helzephyr Lux','Dark','Electricity'},
    ['RedArmorBird']={'Ragnahawk','Fire',''},
    ['Ronin']={'Bushi','Fire',''},
    ['Ronin_Dark']={'Bushi Noct','Fire','Dark'},
    ['FlyingManta']={'Celaray','Water',''},
    ['FlyingManta_Thunder']={'Celaray Lux','Water','Electricity'},
    ['BlackCentaur']={'Necromus','Dark',''},
    ['FlowerDoll']={'Petallia','Leaf',''},
    ['FlowerDoll_Fire']={'Petallia Ignis','Leaf','Fire'},
    ['NaughtyCat']={'Grintale','Normal',''},
    ['CuteButterfly']={'Cinnamoth','Leaf',''},
    ['DarkScorpion']={'Menasting','Dark','Earth'},
    ['DarkScorpion_Ground']={'Menasting Terra','Earth',''},
    ['ThunderDragonMan']={'Orserk','Dragon','Electricity'},
    ['WoolFox']={'Cremis','Normal',''},
    ['LazyCatfish']={'Dumud','Earth','Water'},
    ['LazyCatfish_Gold']={'Dumud Gild','Earth','Water'},
    ['LavaGirl']={'Flambelle','Fire',''},
    ['FlameBambi']={'Rooby','Fire',''},
    ['NightLady']={'Bellanoir','Dark',''},
    ['NightLady_Dark']={'Bellanoir Libero','Dark',''},
    ['MoonQueen']={'Selyne','Dark','Normal'},
    ['KendoFrog']={'Croajiro','Water',''},
    ['KendoFrog_Dark']={'Croajiro Noct','Water','Dark'},
    ['LeafPrincess']={'Lullu','Leaf',''},
    ['MushroomDragon']={'Shroomer','Leaf',''},
    ['MushroomDragon_Dark']={'Shroomer Noct','Leaf','Dark'},
    ['SmallArmadillo']={'Kikit','Earth',''},
    ['CandleGhost']={'Sootseer','Dark','Fire'},
    ['ScorpionMan']={'Prixter','Dark','Earth'},
    ['ScorpionMan_Electric']={'Prixter Lux','Electricity','Earth'},
    ['WingGolem']={'Knocklem','Earth',''},
    ['WingGolem_Fire']={'Knocklem Ignis','Fire',''},
    ['GuardianDog']={'Yakumo','Normal',''},
    ['SifuDog']={'Dogen','Normal',''},
    ['FeatherOstrich']={'Dazemu','Earth',''},
    ['MimicDog']={'Mimog','Normal',''},
    ['DarkAlien']={'Xenovader','Dark',''},
    ['WhiteAlienDragon']={'Xenogard','Dragon',''},
    ['VolcanoDragon']={'Moldron','Fire','Earth'},
    ['VolcanoDragon_Ice']={'Moldron Cryst','Ice','Earth'},
    ['DarkMechaDragon']={'Xenolord','Dark','Dragon'},
    ['GhostRabbit']={'Nitemary','Dark',''},
    ['GhostRabbit_Grass']={'Nitemary Botan','Leaf',''},
    ['NightBlueHorse']={'Starryon','Dark',''},
    ['NightBlueHorse_Neutral']={'Starryon Primo','Normal',''},
    ['WhiteShieldDragon']={'Silvegis','Dragon',''},
    ['BlackPuppy']={'Smokie','Dark',''},
    ['BlackPuppy_Ice']={'Smokie Cryst','Dark','Ice'},
    ['WhiteDeer']={'Celesdir','Normal',''},
    ['WhiteDeer_Dark']={'Celesdir Noct','Dark',''},
    ['KingWhale']={'Panthalus','Water',''},
    ['MysteryMask']={'Omascul','Dark',''},
    ['HoodGhost']={'Hoodle','Dark',''},
    ['Sekhmet']={'Sekhmet','Earth',''},
    ['ElecLizard']={'Slowatt','Electricity',''},
    ['GrimGirl']={'Splatterina','Dark',''},
    ['PurpleSpider']={'Tarantriss','Dark',''},
    ['BlueThunderHorse']={'Azurmane','Electricity',''},
    ['RockBeast']={'Pierdon','Earth',''},
    ['RockBeast_Ice']={'Pierdon Cryst','Ice',''},
    ['OctopusGirl']={'Gloopie','Water','Dark'},
    ['OctopusGirl_Neutral']={'Gloopie Primo','Water','Normal'},
    ['IceNarwhal']={'Whalaska','Ice','Water'},
    ['IceNarwhal_Fire']={'Whalaska Ignis','Ice','Fire'},
    ['JellyfishFairy']={'Jelliette','Water',''},
    ['Kitsunebi_Ice']={'Foxparks Cryst','Ice',''},
    ['BerryGoat_Dark']={'Caprity Noct','Dark',''},
    ['PinkRabbit_Grass']={'Ribbuny Botan','Leaf',''},
    ['Werewolf_Ice']={'Loupmoon Cryst','Ice',''},
    ['AmaterasuWolf_Dark']={'Kitsun Noct','Dark',''},
    ['RaijinDaughter_Water']={'Dazzi Noct','Dark','Electricity'},
    ['WhiteTiger_Ground']={'Cryolinx Terra','Earth',''},
    ['FengyunDeeper_Electric']={'Fenglope Lux','Electricity',''},
    ['Horus_Water']={'Faleris Aqua','Water',''},
    ['SnowTigerBeastman']={'Bastigor','Ice',''},
    ['SnakeGirl']={'Venusa','Dark',''},
    ['GhostAnglerfish']={'Ghangler','Dark','Water'},
    ['GhostAnglerfish_Fire']={'Ghangler Ignis','Fire','Water'},
    ['IceWitch']={'Icelyn','Ice',''},
    ['ClownRabbit']={'Dupin','Fire',''},
    ['LegendDeer']={'Hartalis','Normal',''},
    ['LeafMomonga']={'Herbil','Leaf','Normal'},
    ['SmallYeti']={'Snugloo','Ice',''},
    ['IceCrocodile']={'Munchill','Ice','Water'},
    ['CactusDoll']={'Needoll','Leaf',''},
    ['CactusDoll_Dark']={'Needoll Noct','Dark','Leaf'},
    ['MushroomLady']={'Mycora','Leaf',''},
    ['StuffedShark']={'Finsider','Water',''},
    ['StuffedShark_Fire']={'Finsider Ignis','Water','Fire'},
    ['FoxExorcist']={'Flaracle','Fire',''},
    ['IceSeal']={'Polapup','Ice','Water'},
    ['IceSeal_Ground']={'Polapup Terra','Ice','Earth'},
    ['CloverFairy']={'Clovee','Leaf','Normal'},
    ['ElecPomeranian']={'Puffolt','Electricity',''},
    ['GhostBlackCat']={'Wispaw','Dark',''},
    ['ThiefBird']={'Roujay','Dark',''},
    ['OniGhostGirl']={'Bakemi','Dark',''},
    ['Plesiosaur']={'Braloha','Leaf','Earth'},
    ['TropicalOstrich']={'Palumba','Leaf',''},
    ['GrassGolem']={'Dualith','Earth','Leaf'},
    ['GrassGolem_Dark']={'Dualith Noct','Earth','Dark'},
    ['SnowPeafowl']={'Frostplume','Ice',''},
    ['CubeTurtle']={'Tetroise','Earth',''},
    ['CubeTurtle_Neutral']={'Tetroise Primo','Normal',''},
    ['LongCat']={'Valentail','Normal',''},
    ['JellyfishGhost']={'Jellroy','Water','Dark'},
    ['ThunderFluffyBird']={'Dynamoff','Electricity',''},
    ['MoonChild']={'Wistella','Dark',''},
    ['SamuraiDog']={'Pupperai','Earth',''},
    ['PoseidonOrca']={'Neptilius','Water',''},
    ['SwordCutlassfish']={'Skutlass','Water',''},
    ['SwordCutlassfish_Fire']={'Skutlass Ignis','Water','Fire'},
    ['YakushimaMonster001']={'Green Slime','Leaf',''},
    ['YakushimaMonster001_Blue']={'Blue Slime','Water',''},
    ['YakushimaMonster001_Red']={'Red Slime','Fire',''},
    ['YakushimaMonster001_Purple']={'Purple Slime','Dark',''},
    ['YakushimaMonster001_Pink']={'Illuminant Slime','Normal',''},
    ['YakushimaMonster001_Rainbow']={'Rainbow Slime','Normal',''},
    ['YakushimaMonster002']={'Enchanted Sword','Normal',''},
    ['YakushimaMonster003']={'Cave Bat','Normal',''},
    ['YakushimaMonster003_Purple']={'Illuminant Bat','Normal',''},
    ['YakushimaBoss001']={'Eye of Cthulhu','Dark',''},
    ['YakushimaBoss001_Small']={'Demon Eye','Dark',''},
    ['RAID_YakushimaBoss001_Green']={'True Eye of Cthulhu','',''},
    ['RAID_YakushimaBoss002']={'Moon Lord','',''},
    ['MummyPal']={'Gildra','Dark','Earth'},
    ['KingSunfish']={'Solmora','Water',''},
    ['KingSunfish_Thunder']={'Solmora Lux','Water','Electricity'},
    ['MonochromeQueen']={'Solenne','Dark','Normal'},
    ['ElecSnail']={'Snock','Electricity',''},
    ['ElecSnail_Fire']={'Snock Ignis','Fire',''},
    ['ElecSnail_Ground']={'Snock Terra','Electricity','Earth'},
    ['LanternButler']={'Loomen','Dark','Fire'},
    ['SumoDog']={'Bulldosu','Earth',''},
    ['VenusFlytrap']={'Carnibora','Leaf',''},
    ['StrawHatCat']={'Unidentified Pal','Normal',''},
    ['CandleWitch']={'Unidentified Pal','Dark','Fire'},
    ['FluffyBird']={'Muffly','Ice',''},
    ['DandelionGirl']={'Souffline','Leaf',''},
    ['VolcanicTurtle']={'Unidentified Pal','Fire','Earth'},
    ['ClioneTwins']={'Amione','Water',''},
    ['DarkFlameFox']={'Majex','Dark','Fire'},
    ['RedFlowerBird']={'Tropicaw','Leaf',''},
    ['SleeveRabbit']={'Lapure','Normal',''},
    ['LotusDragon']={'Ophydia','Leaf','Water'},
    ['BlueSkyDragon']={'Shaolong','Dragon','Water'},
    ['PandaGirl']={'Leafan','Leaf',''},
    ['GrassMinotaur']={'Elgrove','Leaf',''},
    ['GrassMinotaur_Ice']={'Elgrove Cryst','Ice',''},
    ['Mothman']={'Silvance','Leaf',''},
    ['GhostDragon']={'Eidrolon','Dragon','Dark'},
    ['GhostDragon_Fire']={'Eidrolon Ignis','Dragon','Fire'},
    ['FlowerPrince']={'Dandilord','Leaf','Dark'},
    ['WorldTreeDragon']={'Astralym','',''},
    ['KabukiMan']={'Renjishi','Fire',''},
    ['DomeArmorDragon']={'Aegidron','Dragon','Earth'},
}
pal_control.basic_skill_choices={
    Normal={{waza=22,skill='Air Cannon'},{waza=11,skill='Power Shot'},{waza=5,skill='Energy Shot'}},
    Fire={{waza=40,skill='Ignis Blast'},{waza=43,skill='Flare Arrow'},{waza=44,skill='Fire Seed'}},
    Water={{waza=57,skill='Aqua Gun'},{waza=62,skill='Aqua Jet'},{waza=63,skill='Bubble Blast'}},
    Ice={{waza=113,skill='Ice Missile'},{waza=116,skill='Icicle Throw'}},
    Leaf={{waza=85,skill='Wind Cutter'},{waza=88,skill='Seed Machine Gun'}},
    Earth={{waza=124,skill='Mud Shot'},{waza=122,skill='Throw Rock'}},
    Electricity={{waza=97,skill='Thunder Ball'},{waza=101,skill='Electric Wave'}},
    Dark={{waza=135,skill='Poison Blast'},{waza=133,skill='Shadow Ball'}},
    Dragon={{waza=148,skill='Dragon Cannon'},{waza=146,skill='Dragon Breath'}},
}
pal_control.basic_catalog_count=308
pal_control.mobile_verified_session=''
pal_control.mobile_selected_profile=nil
function pal_control.basic_candidates(id,kind)
    if kind=='NPC' then
        -- Prioridade: arma equipada (EPalWazaID::Weapon_Use=362), depois soco (Human_Punch=1).
        -- Both require their own action class in the exact possessed NPC.
        return {{name='NPC humano',skill='Disparo com arma equipada',waza=362,cooldown=8,requires_firearm=true},
                {name='NPC humano',skill='Soco',waza=1,cooldown=8}}
    end
    if kind~='PAL' then return {} end
    id=tostring(id or '')
    if #id>100 or not id:match('^[%w_]+$') then return {} end
    local bare=id:gsub('^BOSS_',''):gsub('^GYM_','')
    local item=pal_control.basic_species_catalog[id] or pal_control.basic_species_catalog[bare]
    local special=pal_control.base_attack_profiles[id] or pal_control.base_attack_profiles[bare]
    local choices,used={},{}
    local function add(profile)
        local n=type(profile)=='table' and tonumber(profile.waza) or nil
        if not n or n<4 or n>400 or used[n] or #choices>=9 then return end
        used[n]=true
        choices[#choices+1]={name=profile.name or (item and item[1]) or bare,
            skill=profile.skill or 'Golpe basico',waza=n,
            cooldown=math.max(8,tonumber(profile.cooldown) or 8)}
    end
    if special then add(special) end
    -- HARD+ Astralym is left exclusively on its existing 342 cannon profile.
    if id:find('WorldTreeDragon',1,true) then return choices end
    if item then
        for _,element in ipairs({item[2],item[3]}) do
            local grp=pal_control.basic_skill_choices[element]
            if grp then for _,profile in ipairs(grp) do add(profile) end end
        end
        for _,profile in ipairs(pal_control.basic_skill_choices.Normal) do add(profile) end
    end
    return choices
end

pal_control.base_attack_last_ts=0
pal_control.base_attack_last_cooldown=8
pal_control.base_attack_busy=false
pal_control.base_attack_attempts=0
-- Xbox: a esquiva e APENAS hipotese de RPC/action no servidor dedicado.
-- Nenhum comando de esquiva aciona golpe sem DODGEARM, owner/pawn exatos e origem identificada.
pal_control.dodge_hook_installed=false
pal_control.dodge_hook_attempts=0
pal_control.dodge_hook_events=0
pal_control.dodge_owner_events=0
pal_control.dodge_unresolved_events=0
pal_control.dodge_rpc_candidates=0
pal_control.dodge_attack_calls=0
pal_control.dodge_armed=false
pal_control.dodge_armed_session=nil
pal_control.dodge_queued=false
pal_control.dodge_last_trigger=0
-- Avisos privados de golpe, posse e retorno: resultados finais ou bloqueios apenas.
-- Janelas separadas evitam que CHECK/CAMERA oculte o resultado do TRIAL.
pal_control.private_result_notices=true
pal_control.private_last_ts=0
pal_control.private_last_ts_by_group={}
pal_control.private_notice_queued=false
local BOSS_MODE_DIAGNOSTIC_ONLY=false -- avatar temporario; saida manual sem timer, combate PvE nao validado
local REQUEST_FILE = 'Mods/CVGBossControl/cvg_v06_request.txt'
local OWNER_FILE = 'Mods/CVGBossControl/cvg_owner_playerid_v04.txt'
local RECOVERY_FILE = 'Mods/CVGBossControl/cvg_recovery_v18.txt'
local last_request, seen, decoded = nil, 0, 0
local chat_armed=false
local chat_armed_until=0
local CHAT_ARM_TTL_SECONDS=1800 -- renovar com !cvg ping; RETURN sem armamento
local last_chat_action, last_chat_action_ts=nil,nil
local skill_last_call_ts=nil
local interact_sync_generation=0
local interact_sync_manual_ts=0
local SKILL_MIN_INTERVAL_SECONDS=3 -- evita multiplas chamadas consecutivas ao nativo
local admin_busy, view_busy, aim_busy, origin_busy, near_busy = false, false, false, false, false
local last_near_scan_ts=nil
local NEAR_SCAN_LIMIT=128
local NEAR_RADIUS_CM=1500
local NEAR_COOLDOWN_SECONDS=45
local previous_origin=nil
-- Nenhum limite artificial de tentativas ou de intervalo; so session/recovery lock.
local trial=nil
-- CVG Pal Control mobile bridge (EXPERIMENTAL): status explicit, no polling of native skills.
-- Auth is enforced by GameGrid API file scopes AND exact PC/pawn checks below.
-- No app API key is stored here. Do not install on public CVG until clone tests.
pal_control.MOBILE_STATE_FILE = 'Mods/CVGBossControl/cvg_mobile_status.json'
pal_control.mobile_tracked_trial=nil
pal_control.mobile_session_serial=0
pal_control.mobile_session_token=''
pal_control.mobile_armed_token=''
pal_control.mobile_last_result='NONE'
pal_control.mobile_last_state_signature=nil
pal_control.mobile_state_last_write=0
pal_control.target_lock=nil
pal_control.target_last_result='SEM_ALVO'
pal_control.target_busy=false
pal_control.mobile_display_by_class={SheepBall='Lamball',ChickenPal='Chikipi',PinkCat='Cattiva',Garm='Direhowl',Boar='Rushoar',WorldTreeDragon='Astralym'}
local boss_cleanup_after_return=nil -- set once after NPC cleanup is defined
-- Retorno primeiro, limpeza de corpo morto depois. NUNCA remover no callback OnDeadCharacter.
pal_control.dead_pal_cleanup_after_return=nil
pal_control.dead_pal_despawn_enabled=true -- clone experimental SOMENTE
pal_control.dead_pal_despawn_grace_ms=6000 -- permitir eventos e coleta do OnDeadCharacter
pal_control.dead_pal_despawn_postcheck_ms=1800
local trial_op_busy=false
pal_control.handoff_pending=nil -- only one in-flight spectator->human->Pal handoff; no loop
pal_control.handoff_serial=0
local ai_postcheck_pending=false
local ai_recovery_uncertain=false
-- A falta de UMA acao instantanea nao comprova IA quebrada quando a IA
-- estava INATIVA antes e continua INATIVA depois. Na v1.10.2, depois de
-- duas leituras e checagem da identidade, tentar reativar SOMENTE o controlador
-- original se a acao sumiu. Em falha, isolar o ator em quarentena sem bloquear
-- outros NPCs/Pals. Nao repetir SetActiveAI em loop.
-- Guarda so identificadores nao pessoais de atores; sem scan global.
local ai_action_quarantine={}
local AI_POSTCHECK_DELAY_MS=1200
local AI_FINALCHECK_DELAY_MS=900
local jump_hook_installed=false
local death_hook_installed=false
local capture_hook_installed=false
local capture_hook_retry_queued=false
local cam_baseline=nil
local cam_previous=nil
local cam_sync=nil
local spectator_hook_installed=false
local SPECTATOR_SYNC_MAX_AGE_SEC=45 -- janela para digitar CAMPAL no Xbox; RPC autenticado + movimento + IsSpectating obrigatorios
local SPECTATOR_SYNC_MIN_MOVE_CM=100
local SPECTATOR_SYNC_LOG_THROTTLE=5
local CAMERA_AIM_RADIUS_CM=1500 -- somente com rotacao do RPC do Xbox confirmada; senao 8m.
local CAMERA_AIM_MAX_YAW_DEG=30
local CAMERA_AIM_MAX_PITCH_DEG=55 -- tolera raiz do Pal no chao, nao e reticulo real.
local CAMERA_AIM_MAX_3D_DEG=50
local CAMERA_AIM_MIN_SCORE_GAP=7 -- bloquear empate angular de alvos multiplos.
-- Trava distante provavelmente envolve world streaming ligado ao humano original.
-- Por pedido anterior, nao forcar retorno por distancia sem comando explicito.
local stream_safe_enabled=false
local STREAM_SAFE_RETURN_CM=17000 -- SAFEON: retorno preventivo a 170m, opcional.

local cam_busy=false
local CAM_CHECK_MAX_OBJECTS=128
local CAM_CHECK_MAX_DISTANCE_CM=3000
local CAM_CHECK_CONE_DEG=20
-- Posse a partir de camera de espectador autenticada no servidor.
-- A camera so e elegivel se sua posicao REAL for visivel e movel no dedicated server.
-- Usar rotacao confirmada do MESMO RPC Xbox quando disponivel; fallback proximidade.
local CAMERA_TRIAL_RADIUS_CM=1200 -- 12m no fallback sem yaw RPC; alvo unico com separacao obrigatoria
local CAMERA_MOTION_MIN_CM=100 -- entre 2 probes: 1m de deslocamento confirmado
local CAMERA_PROBE_MAX_AGE_SEC=60 -- tempo para digitar comando CAM após leitura no Xbox
local CAMERA_HUMAN_MAX_DRIFT_CM=1000 -- tolerar ate 10m de drift NATIVO; identidade, classe, GUID e controller sempre obrigatorios
local JUMP_WINDOW_SECONDS=5  -- tres eventos nativos OnJumped em ate 5s (segundos inteiros)
local recovery_lock=false
local recovery_class=nil
local RECOVERY_MAX_NATIVE_RESTORES=2
-- Otimizacao experimental de replicacao, somente de UM Pal atualmente possuido.
-- Nao altera o humano, o jogador, os outros Pals, streaming global ou saves.
-- Modo OFF por padrao; !cvg rangeon arma pro proximo TRIAL; rangeoff desarma.
-- Unreal nao garante que isso altere o limite de simulacao do Palworld.
local range_boost_enabled=false
local RANGE_NET_CULL_CM=20000  -- 200m; NetCullDistanceSquared e em centimetros^2.
-- Rede exclusivamente do ator original possuido, Pal ou NPC (nao muda PlayerState,
-- NPCs alheios, saves, transform do humano ou a origem do world streaming).
local POSSESSION_NET_CULL_CM=300000 -- 3km, distancia 3D; nao e streaming mundial
pal_control.NET_NPC_CULL_CM=500000 -- 5km only on exact possessed NPC actor
pal_control.NET_NPC_PULSE_SEC=2
function pal_control.possession_net_cull_cm(st)
    if st and st.target_kind=='NPC' then return pal_control.NET_NPC_CULL_CM end
    return POSSESSION_NET_CULL_CM
end
local POSSESSION_NET_UPDATE_HZ=40
local POSSESSION_NET_MIN_HZ=15
local POSSESSION_NET_PULSE_SEC=4 -- apenas ForceNetUpdate no ator atual, nao RPC de camera
local POSSESSION_NET_DIAG_SEC=20 -- amostragem limitada, apenas humano e alvo
local RANGE_PROBE_STEP_MS=10000
local RANGE_PROBE_MAX_SAMPLES=24 -- 4 min, um par de posicoes a cada 10s, sem FindAllOf.
-- No wild-possession duration timer in v1.10.0.
-- Somente UM callback agendado por trial: NAO cria watchdog por segundo.
-- Retorno tambem por 3 pulos ou RETURN sequencial no arquivo privado.
-- Monitor de desconexao AUTOMATICO eliminado (nenhum FindAllOf por segundo durante a possessao).
local ghost=nil -- somente humano ORIGINAL rastreado em uma TRIAL nesta mesma sessao Lua
local GHOST_INSPECT_WINDOW=90
local TRIAL_MAX_OBJECTS=1024
local TRIAL_MIN_DISTANCE_CM=20 -- tolera Pal muito perto (origem de ator nao e o hitbox)
local TRIAL_MAX_DISTANCE_CM=3000 -- alcance de SEGURANCA, NAO o alcance do reticulo Xbox
local TRIAL_CONE_DEGREES=15 -- apenas diagnostico, NAO decide a escolha

local notice_callback=nil
local function log(msg)
    print('[CVG Boss Control v'..VERSION..'] '..msg..'\n')
    -- Os avisos sao tentativa de entrega, NUNCA substituem a trilha de auditoria.
    -- Envia apenas status relevantes ao dono; jamais despeja UID ou erro interno no jogo.
    -- Reativacao seletiva: nunca emitir notificação de cada hook, frame ou log de status.
    -- A entrega via PalUtility e experimental; pcall nao protege de crash nativo.
    -- Encaminhar apenas UM RESULTADO final/bloqueio por operacao, nao fases do
    -- scan/algoritmo, frames, jogadores ou progresso de streaming. Nenhum log bruto
    -- de identificadores e enviado ao Xbox.
    local group=nil
    if msg:find('^MSGTEST_OK') then group='test'
    elseif msg:find('^CVG_RT_ARMED:') or msg:find('^CVG_RT_DISARMED:') or msg:find('^CVG_RT_ARM_BLOCKED:') then group='rtcontrol'
    elseif msg:find('^CVG_BASEATTACK_RESULT:') or msg:find('^PAL_OWN_SKILLS_MANUAL_RESULT:')
        or msg:find('^PAL_OWN_SKILL_AUTO_RESULT:') or msg:find('^CVG_RT_AUTO_RESULT:')
        or msg:find('^ASTRALYM341_NATIVE_RETURN:') or msg:find('^ASTRALYM341_BLOCKED:') then group='attack'
    elseif msg:find('^CVG_DODGE_ARMED:') or msg:find('^CVG_DODGE_DISARMED:')
        or msg:find('^CVG_DODGE_BLOCKED:') then group='dodge'
    elseif msg:find('^RETURN_') or msg:find('^CVG_HANDOFF_MANUAL_CANCEL:') then
        -- Nao emitir RETURN_STAGE_* para evitar aviso prematuro.
        if msg:find('^RETURN_CALLED:') or msg:find('^RETURN_FAILED:')
            or msg:find('^RETURN_PARTIAL:') or msg:find('^RETURN_UNCERTAIN:')
            or msg:find('^RETURN_IDLE:') or msg:find('^RETURN_BUSY:')
            or msg:find('^CVG_HANDOFF_MANUAL_CANCEL:') then group='return' end
    elseif msg:find('^TRIAL_CALLED:') or msg:find('^NPC_TRIAL_CALLED:')
        or msg:find('^TRIAL_BLOCKED') or msg:find('^TRIAL_CALL_FAILED:')
        or msg:find('^TRIAL_FAILED:') or msg:find('^TRIAL_UNAVAILABLE:')
        or msg:find('^TRIAL_BUSY:') or msg:find('^TRIAL_RETRY_NEEDS_HUMAN:')
        or msg:find('^TRIAL_HANDOFF_PENDING:')
        or msg:find('^NPC_TRIAL_BLOCKED:') or msg:find('^NPC_TRIAL_RETRY_NEEDS_HUMAN:')
        or msg:find('^CAMPAL_TRIAL_BLOCKED:') or msg:find('^CAMBOSS_TRIAL_BLOCKED:')
        or msg:find('^CAMNPC_TRIAL_BLOCKED:')
        or msg:find('^CAMPAL_TRIAL_RETRY_NEEDS_HUMAN:') or msg:find('^CAMBOSS_TRIAL_RETRY_NEEDS_HUMAN:')
        or msg:find('^CVG_HANDOFF_ABORTED:') or msg:find('^CVG_HANDOFF_FAILED:')
        or msg:find('^CVG_HANDOFF_CANCELLED:') or msg:find('^CVG_HANDOFF_LUA_ERROR:')
        or msg:find('^CAMPAL_TRIAL_FAILED:') or msg:find('^CAMBOSS_TRIAL_FAILED:') then group='possession'
    elseif msg:find('^CHECK_READY:') or msg:find('^NPC_CHECK_READY:')
        or msg:find('^CAMPAL_CHECK_READY:') or msg:find('^CAMBOSS_CHECK_READY:')
        or msg:find('^CAMNPC_CHECK_READY:') or msg:find('^CHECK_BLOCKED:')
        or msg:find('^CAMPAL_CHECK_BLOCKED:') or msg:find('^CAMBOSS_CHECK_BLOCKED:')
        or msg:find('^CAMNPC_CHECK_BLOCKED:') then group='check'
    elseif msg:find('^CAMARM_OK:') or msg:find('^CAMARM_BLOCKED:')
        or msg:find('^CAM_BLOCKED:') or msg:find('^CAM_RETRY_NEEDS_HUMAN:')
        or msg:find('^CAM_PROBE_OK:') then group='camera'
    elseif msg:find('^CVGSPEC_START_CALLED:') or msg:find('^CVGSPEC_REUSED_GAME_SPECTATE:')
        or msg:find('^CVGSPEC_BLOCKED:') or msg:find('^CVGSPEC_START_FAILED:')
        or msg:find('^CVGSPEC_END_OK:') or msg:find('^CVGSPEC_END_BLOCKED:')
        or msg:find('^CVGSPEC_END_FAILED:') or msg:find('^CVGSPEC_END_UNCONFIRMED:') then group='spectate'
    elseif msg:find('^RECOVERY_STATUS_') or msg:find('^CHAT_PING_OK:') then group='status' end
    if pal_control.private_result_notices and group~=nil and notice_callback~=nil
       and not pal_control.private_notice_queued and type(ExecuteInGameThread)=='function' then
        local now=os.time()
        local prev=pal_control.private_last_ts_by_group[group] or 0
        -- Maximo um aviso por grupo em 5s. Golpe, posse e retorno nao se anulam.
        if type(now)=='number' and now-prev>=5 then
            pal_control.private_last_ts_by_group[group]=now
            pal_control.private_last_ts=now
            pal_control.private_notice_queued=true
            local scheduled=pcall(function()ExecuteInGameThread(function()
                local ok=pcall(notice_callback,msg)
                pal_control.private_notice_queued=false
                if not ok then print('[CVG Boss Control v'..VERSION..'] PRIVATE_NOTICE_LUA_ERROR: log_retained=true\n') end
            end)end)
            if not scheduled then
                pal_control.private_notice_queued=false
                print('[CVG Boss Control v'..VERSION..'] PRIVATE_NOTICE_QUEUE_FAILED: log_retained=true\n')
            end
        end
    end
end
local function valid(o)
    if o == nil then return false end
    local ok, val = pcall(function() return o:IsValid() end)
    return ok and val == true
end
-- Read-only check to avoid mistaking melee tools/empty slots for NPC firearms.
function pal_control.npc_firearm_present(s)
    if not s or s.target_kind~='NPC' or not valid(s.pal) then return false end
    local ok,shooter=pcall(function()return s.pal.ShooterComponent end)
    if not ok or not valid(shooter) then return false end
    local got,weapon=pcall(function()return shooter:GetHasWeapon() end)
    if not got or not valid(weapon) then
        local fallback,obj=pcall(function()return shooter.HasWeapon end)
        if not fallback or not valid(obj) then return false end
        weapon=obj
    end
    local named,fullname=pcall(function()return tostring(weapon:GetFullName()) end)
    if not named or type(fullname)~='string' then return false end
    local name=fullname:lower()
    -- Exclude explosive launchers and non-gun tools; never change inventory.
    for _,skip in ipairs({'grenade','rocket','missile','cannon','sphere','palball','bow','spear','knife','sword','pickaxe'}) do
        if name:find(skip,1,true) then return false end
    end
    for _,gun in ipairs({'gun','rifle','pistol','revolver','shotgun','smg','machinegun','gatling','laser','flamethrower','flame_thrower'}) do
        if name:find(gun,1,true) then return true end
    end
    return false
end

local function owner_guid()
    local f = io.open(OWNER_FILE, 'r')
    if not f then return nil, 'owner GUID file absent' end
    local ok, raw = pcall(function() return f:read('*a') end)
    f:close()
    if not ok or type(raw)~='string' then return nil, 'owner GUID file unreadable' end
    local v = raw:match('^%s*([0-9a-fA-F]+)%s*$')
    if not v or #v~=32 or v==string.rep('0',32) then return nil,'owner GUID invalid' end
    return v:lower()
end
local function guid(v)
    if v==nil then return nil end
    local ok,a,b,c,d = pcall(function() return v.A,v.B,v.C,v.D end)
    if not ok then return nil end
    if type(a)~='number' or type(b)~='number' or
       type(c)~='number' or type(d)~='number' then return nil end
    return string.format('%08x%08x%08x%08x',a&0xffffffff,b&0xffffffff,
        c&0xffffffff,d&0xffffffff)
end
-- Notificacao privada por PalUtility: mesma API do mod AdminCommands que ja
-- esta ativo no servidor. Ainda NAO comprovada neste servidor especifico/Xbox.
-- FGuid translate em AdminCommands equivale a {A,B,C,D}; nao precisa importar libs.

-- v1.8 Recovery journal: no player identifiers or actor paths are persisted.
-- When the server process dies, the Lua UObject references are lost forever.
-- An ACTIVE marker survives restart to BLOCK new native possession until the
-- verified owner confirms their avatar is a human player (never guess/reset).
local function pawn_class_name(pawn)
    if not valid(pawn) then return nil end
    local ok,name=pcall(function()
        local cls=pawn:GetClass()
        if not valid(cls) then return nil end
        return cls:GetFName():ToString()
    end)
    if ok and type(name)=='string' and #name>0 and #name<=96 then return name end
    return nil
end
-- Identidade de atores pela chave do UObject nativo; duas wrappers Lua
-- distintas podem referenciar o MESMO ator. Sem chave -> fail closed.
-- Nao registrar a chave do ator nos logs nem gravar em disco.
local function actor_key(obj)
    if not valid(obj) then return nil end
    local ok,result=pcall(function()return obj:GetFullName()end)
    if ok and type(result)=='string' and #result>=5 and #result<=400 then return result end
    return nil
end

-- Um corpo original pode persistir no mundo apos o jogo criar NOVO humano.
-- Guardamos SOMENTE a referencia que capturamos ANTES da possessao. Nunca
-- inferimos que um outro PlayerCharacter sem nome pertence a este jogador.
local function track_old_human_if_distinct(state,current)
    if not state or not state.offline or not valid(state.human) then return end
    local old_key,new_key=actor_key(state.human),actor_key(current)
    if not old_key or not new_key then
        log('GHOST_UNTRACKED: actor native identity unavailable; no cleanup permitted')
        return
    end
    if old_key==new_key then return end
    local old_cls=pawn_class_name(state.human)
    local new_cls=pawn_class_name(current)
    if not old_cls or old_cls~=state.human_class or new_cls~=state.human_class then
        log('GHOST_UNTRACKED: human class mismatch; no cleanup permitted')
        return
    end
    ghost={old=state.human,old_key=old_key,new_key=new_key,
           human_class=state.human_class,tracked_at=os.time(),
           inspected_at=nil,cleanup_called=false}
    log('GHOST_TRACKED: previous original human actor still referenced; cleanup NOT automatic; use !cvg ghost; no actor modified')
end

local function recovery_journal_read()
    local f=io.open(RECOVERY_FILE,'r')
    if not f then return false,nil end -- first installation, no previous trial
    local ok,raw=pcall(function()return f:read(160)end)
    f:close()
    if not ok or type(raw)~='string' then return true,nil end
    if raw:match('^SAFE%s*$') then return false,nil end
    local cls=raw:match('^ACTIVE%s+([%w_]+)%s*$')
    if cls and #cls<=96 then return true,cls end
    return true,nil -- corruption is fail-closed
end
local function recovery_journal_write(active,classname)
    local content
    if active then
        if type(classname)~='string' or #classname>96 or
           not classname:match('^[%w_]+$') then return false end
        content='ACTIVE '..classname..'\n'
    else
        content='SAFE\n'
    end
    local ok=pcall(function()
        local f=assert(io.open(RECOVERY_FILE,'w'))
        assert(f:write(content))
        assert(f:flush())
        assert(f:close())
    end)
    if not ok then return false end
    local pending,stored_class=recovery_journal_read()
    if active then return pending and stored_class==classname end
    return pending==false
end
local function verified_owner_online(require_admin)
    local expected=owner_guid()
    if not expected or type(FindAllOf)~='function' then return nil,0,'owner credential/API unavailable' end
    local count,owner_pc,owners=0,nil,0
    local ok=pcall(function()
        for _,pc in ipairs(FindAllOf('PalPlayerController') or {}) do
            if valid(pc) and pc:HasAuthority()==true then
                count=count+1
                if guid(pc:GetPlayerUId())==expected then
                    owner_pc=pc
                    owners=owners+1
                end
            end
        end
    end)
    if not ok then return nil,count,'controller scan failed' end
    if owners~=1 then return nil,count,owners==0 and 'owner offline' or 'duplicate owner controllers' end
    if require_admin and owner_pc.bAdmin~=true then return nil,count,'owner admin inactive' end
    return owner_pc,count,nil
end
local function pawn_matches_human(pawn,expected_class)
    return type(expected_class)=='string' and pawn_class_name(pawn)==expected_class
end
-- A limpeza de um PlayerCharacter e POTENCIALMENTE DESTRUTIVA.
-- APENAS um humano ORIGINAL salvo por esta versao antes de Possess e
-- comprovadamente diferente do humano atual pode virar candidato.
-- Limpeza manual e em 2 etapas: !cvg ghost e depois !cvg cleanup.
-- A copia que ja existia ANTES da v1.8.3 nunca e elegivel.
local function ghost_check()
    if not ghost then return false,'no_tracked_original' end
    if ghost.cleanup_called then return false,'cleanup_already_called' end
    if trial or recovery_lock then return false,'possession_or_recovery_pending' end
    if not valid(ghost.old) then
        ghost=nil
        return false,'old_actor_invalid_no_cleanup_needed'
    end
    if actor_key(ghost.old)~=ghost.old_key then return false,'original_actor_identity_changed' end
    if pawn_class_name(ghost.old)~=ghost.human_class then return false,'original_human_class_changed' end
    local ok_auth,authority=pcall(function()return ghost.old:HasAuthority()end)
    if not ok_auth or authority~=true then return false,'original_actor_not_server_authoritative' end
    local pc,count,reason=verified_owner_online(true)
    if not pc then return false,'owner_admin_missing_or_ambiguous' end
    -- Apenas para a operacao de exclusao: exigimos estar SOZINHO,
    -- embora a possessao normal continue autorizada em multiplayer.
    if count~=1 then return false,'cleanup_requires_only_owner_online' end
    local ok,current=pcall(function()return pc:K2_GetPawn()end)
    if not ok or not pawn_matches_human(current,ghost.human_class) then
        return false,'owner_not_controlling_verified_human'
    end
    local current_key=actor_key(current)
    if not current_key or current_key==ghost.old_key or current_key~=ghost.new_key then
        return false,'current_human_identity_changed_or_original_still_controlled'
    end
    -- Nunca destruir um ator se houver Controller valido (ate AI ou offline).
    local ok_controller,controller=pcall(function()return ghost.old.Controller end)
    if not ok_controller or valid(controller) then return false,'old_human_still_has_controller' end
    -- Checagem redundante: nenhum PlayerController pode controlar o original.
    local ok_scan,occupied=pcall(function()
        for _,candidate in ipairs(FindAllOf('PalPlayerController') or {}) do
            if valid(candidate) and candidate:HasAuthority()==true then
                local candidate_pawn=candidate:K2_GetPawn()
                local candidate_key=actor_key(candidate_pawn)
                if not candidate_key then return true end
                if candidate_key==ghost.old_key then return true end
            end
        end
        return false
    end)
    if not ok_scan or occupied then return false,'controller_scan_uncertain_or_actor_in_use' end
    return true,'tracked_original_is_unpossessed'
end
local function ghost_status()
    if not ghost then return 'GHOST_NOT_TRACKED: existing old copies cannot be safely identified; no actors modified' end
    local eligible,why=ghost_check()
    if not eligible then return 'GHOST_BLOCKED: '..why..'; no actors modified' end
    ghost.inspected_at=os.time()
    return 'GHOST_READY: old original tracked and not controlled; ONLY manual !cvg cleanup can request deletion; risky for saves'
end
local post_cleanup_verify=nil -- definida apos as rotinas de confirmacao do humano
local function ghost_cleanup()
    if not ghost then return 'GHOST_CLEAN_BLOCKED: no tracked original; never delete old unknown player bodies' end
    local eligible,why=ghost_check()
    if not eligible then return 'GHOST_CLEAN_BLOCKED: '..why..'; no native deletion' end
    local now=os.time()
    if type(now)~='number' or type(ghost.inspected_at)~='number' or
       now<ghost.inspected_at or now-ghost.inspected_at>GHOST_INSPECT_WINDOW then
        return 'GHOST_CLEAN_BLOCKED: first run !cvg ghost; confirmation expires after 90s'
    end
    -- Ao contrario de objetos comuns, K2_DestroyActor em PalPlayerCharacter
    -- pode ter efeitos nos saves. Usuario deve ter backup RESTAURAVEL.
    local ref=ghost.old
    ghost.cleanup_called=true -- nunca repetir chamada nativa no mesmo ator
    local ok=pcall(function()ref:K2_DestroyActor()end)
    if not ok then
        return 'GHOST_CLEAN_UNCERTAIN: K2_DestroyActor raised Lua error; do not repeat; operator review required'
    end
    -- Desbloqueio automatico SO quando o ator ANTIGO realmente deixar de ser
    -- valido E o admin estiver controlando exatamente o novo humano salvo.
    -- Agendar duas verificacoes leves, SEM fazer outras chamadas nativas de exclusao.
    if type(ExecuteWithDelay)=='function' and type(ExecuteInGameThread)=='function' then
        local cleanup_record=ghost
        for _,ms in ipairs({1500,6000}) do
            local scheduled=pcall(function()
                ExecuteWithDelay(ms,function()
                    if ghost~=cleanup_record or not cleanup_record.cleanup_called then return end
                    local dispatched=pcall(function()
                        ExecuteInGameThread(function()
                            if ghost~=cleanup_record then return end
                            if type(post_cleanup_verify)=='function' then
                                local worked,result=pcall(post_cleanup_verify)
                                if worked then log(result) else log('GHOST_CLEAN_RECHECK_ERROR: Lua verification error; trial remains locked') end
                            end
                        end)
                    end)
                    if not dispatched then log('GHOST_CLEAN_RECHECK_UNAVAILABLE: game-thread dispatch failed; use !cvg status') end
                end)
            end)
            if not scheduled then log('GHOST_CLEAN_RECHECK_UNAVAILABLE: delay scheduling failed; use !cvg status') end
        end
    else
        log('GHOST_CLEAN_RECHECK_UNAVAILABLE: timer unavailable; verification on next !cvg status/trial')
    end
    return 'GHOST_CLEAN_CALLED: old body destroy requested; automatic unlock ONLY after invalid-old and verified-new-human; not yet proof of removal'
end

local function recovery_status()
    if trial then
        if trial.offline then return 'RECOVERY_STATUS_OFFLINE: trial pending; no auto reconnect monitoring; use !cvg status after human returns' end
        if trial.temporary_boss then return 'RECOVERY_STATUS_BOSS_ACTIVE: NO TIME LIMIT; return MANUALLY by Android TXT RETURN or 3 jumps/chat; no disconnect watchdog' end
        return 'RECOVERY_STATUS_ACTIVE: MANUAL RETURN; no duration/distance cutoff; client sync is experimental'
    end
    if recovery_lock then
        return 'RECOVERY_STATUS_AUTO_RETRY: previous journal ACTIVE; new TRIAL/CVGSPEC attempts automatic owner-human verification and recovery'
    end
    if ai_postcheck_pending then
        return 'RECOVERY_STATUS_AI_CHECK_PENDING: humano restaurado; Wild AI postcheck pendente; NOVAS possessoes permitidas se humano verificado'
    end
    if ai_recovery_uncertain then
        return 'RECOVERY_STATUS_AI_UNCERTAIN: IA do Pal anterior nao verificada; novas possessoes permitidas com aviso; veja logs AI_'
    end
    if ghost then
        return 'RECOVERY_STATUS_GHOST_ADVISORY: previous original body possibly exists; no deletion performed; retries allowed if owner human verified'
    end
    local q_count=0
    for _ in pairs(ai_action_quarantine) do q_count=q_count+1 end
    return 'RECOVERY_STATUS_SAFE: no active trial or unresolved crash marker; other players permitted; quarantined_actor_count='..q_count..'; avoid a quarantined actor until AI and action return'
end
local function confirm_recovered_human()
    if trial~=nil then return 'RECOVERY_CLEAR_BLOCKED: live trial still active; use !cvg return or wait for recovery' end
    if not recovery_lock then return 'RECOVERY_CLEAR_OK: no pending recovery marker' end
    if type(recovery_class)~='string' then
        return 'RECOVERY_CLEAR_BLOCKED: marker corrupt or old class unknown; manual operator inspection required'
    end
    local pc,count,reason=verified_owner_online(true)
    if not pc then return 'RECOVERY_CLEAR_BLOCKED: owner/admin verification failed' end
    local ok,pawn=pcall(function()return pc:K2_GetPawn()end)
    if not ok or not valid(pawn) or not pawn_matches_human(pawn,recovery_class) then
        return 'RECOVERY_CLEAR_BLOCKED: server cannot verify the original human class; no mutation performed'
    end
    if not recovery_journal_write(false) then return 'RECOVERY_CLEAR_BLOCKED: cannot save SAFE marker; check file permissions' end
    recovery_lock=false;recovery_class=nil
    return 'RECOVERY_CLEAR_OK: human class validated and journal cleared; confirm Xbox movement'
end

-- v1.8.8: depois de !cvg cleanup, a versao antiga deixava ghost=... mesmo
-- quando o ator ja havia desaparecido; TRIAL ficava bloqueado para sempre.
-- Reconciliar APENAS com owner unico/admin, humano atual de mesma classe
-- e da mesma identidade nativa registrada quando ocorreu a reconexao.
-- NUNCA limpar um ghost ainda valido: exclusao pode falhar/ser atrasada.
local function reconcile_cleaned_ghost()
    if not ghost then return true,'no_tracked_ghost' end
    local pc,_,why=verified_owner_online(true)
    if not pc then return false,'owner_missing_or_ambiguous' end
    local ok,pawn=pcall(function()return pc:K2_GetPawn()end)
    if not ok or not valid(pawn) or not pawn_matches_human(pawn,ghost.human_class) then
        return false,'current_human_not_verified'
    end
    local key=actor_key(pawn)
    if not key or key~=ghost.new_key or key==ghost.old_key then
        return false,'human_identity_not_originally_tracked_new_body'
    end
    if valid(ghost.old) then
        if ghost.cleanup_called then return false,'old_body_still_valid_after_cleanup' end
        return false,'old_body_still_valid_and_not_cleaned'
    end
    -- No old actor exists; no deletion performed here.
    ghost=nil
    return true,'old_body_invalid_and_current_human_verified'
end
post_cleanup_verify=function()
    if trial then return 'GHOST_CLEAN_PENDING: possession still active; trial locked' end
    if not ghost then return 'GHOST_CLEAN_VERIFIED: no tracked old actor; status SAFE must still be checked' end
    if not ghost.cleanup_called then return 'GHOST_CLEAN_PENDING: manual cleanup not requested; trial locked' end
    local ok,why=reconcile_cleaned_ghost()
    if not ok then return 'GHOST_CLEAN_PENDING: '..why..'; trial remains locked' end
    if recovery_lock then
        local confirmed=confirm_recovered_human()
        if not confirmed:find('^RECOVERY_CLEAR_OK') then
            return 'GHOST_CLEAN_PENDING: journal not cleared; '..confirmed
        end
    end
    return 'GHOST_CLEAN_VERIFIED: old body invalid, owner controlling tracked human, journal SAFE; another trial permitted'
end
local function recover_after_cleanup()
    if trial then
        return 'RECOVER_BLOCKED: trial still active; use 3 jumps or RETURN TXT'
    end
    local ok,reason=reconcile_cleaned_ghost()
    if not ok then return 'RECOVER_BLOCKED: '..reason..'; no journal cleared' end
    if recovery_lock then
        local cleared=confirm_recovered_human()
        if not cleared:find('^RECOVERY_CLEAR_OK') then
            return 'RECOVER_BLOCKED: journal confirmation failed; '..cleared
        end
    end
    return 'RECOVER_OK: '..reason..'; recovery status SAFE; Xbox human movement still requires player confirmation'
end

recovery_lock,recovery_class=recovery_journal_read()
local utility_cache=nil
local function format_player_notice(message)
    if message:find('^PAL_SAFETY_DIAG') then return '[CVG] MORTE: gancho tentado. CAPTURA: gancho opcional. Eventos nao garantem recuperacao; veja log.' end
    if message:find('^PAL_DANGER_DETECTED') then return '[CVG] ALERTA: morte/captura do Pal controlado! Tentando voltar ao humano.' end
    if message:find('^PAL_DANGER_RETURN_BLOCKED') then return '[CVG] ALERTA: retorno por perigo incerto. Nao repita TRIAL; veja status e log.' end
    if message:find('^PAL_DANGER_RETURN_REQUESTED') then return '[CVG] ALERTA: pedindo retorno ao humano apos perigo do Pal.' end
    if message:find('^JUMP_DIAG_READY') then return '[CVG] SALTOS: gancho instalado; 3 pulos em ate 5s serao TESTADOS. Xbox nao validado.' end
    if message:find('^JUMP_DIAG_UNAVAILABLE') then return '[CVG] SALTOS INDISPONIVEIS. Para voltar use RETURN no TXT do Android.' end
    if message:find('^CAMARM_OK') then return '[CVG] Camera preparada. Entre /spectate e use CAM 18701 no TXT Android.' end
    if message:find('^CAM_PROBE_OK') then return '[CVG] Camera lida pelo servidor. Veja movimento no log; ainda sem possessao pela camera.' end
    if message:find('^CAMCHECK_CANDIDATE') then return '[CVG] Pal proximo da camera detectado em diagnostico. Alvo ainda NAO autorizado para Possess.' end
    if message:find('^CAMPAL_CHECK_READY') or message:find('^CAMBOSS_CHECK_READY') or message:find('^CAMNPC_CHECK_READY') then return '[CVG] Candidato proximo da camera SERVER confirmado. Posse ainda nao executada; use CAMPAL/CAMBOSS/CAMNPC.' end
    if message:find('^CAMBOSS_TRIAL_BLOCKED') or message:find('^CAMBOSS_CHECK_BLOCKED') or message:find('^CAMPAL_TRIAL_BLOCKED') or message:find('^CAMNPC_TRIAL_BLOCKED') or message:find('^CAMPAL_CHECK_BLOCKED') or message:find('^CAMNPC_CHECK_BLOCKED') then
        if message:find('STALE_OR_STATIC',1,true) or message:find('MOVING_ON_SERVER',1,true) then
            return '[CVG] CAMPAL: sinal da camera vencido ou sem movimento. Mova a camera 1m, depois envie CAMPAL.'
        end
        if message:find('SPECTATOR_NOT_PROVEN',1,true) or message:find('SERVER_SPECTATOR_NOT_PROVEN',1,true) then
            return '[CVG] CAMPAL: camera Xbox nao confirmada no servidor. Reabra espectador e mova 1m.'
        end
        if message:find('ambiguo',1,true) or message:find('dois alvos',1,true) then
            return '[CVG] CAMPAL: dois Pals proximos. Isole o alvo ou aproxime mais a camera.'
        end
        if message:find('camera cone',1,true) then
            return '[CVG] CAMPAL: nenhum Pal confirmado no campo de visao da camera.'
        end
        if message:find('within ',1,true) or message:find('found=0',1,true) then
            return '[CVG] CAMPAL: nao ha Pal elegivel perto da camera do servidor.'
        end
        return '[CVG] CAMPAL BLOQUEADO: sem alvo/camera comprovados. O motivo exato esta no UE4SS.log.'
    end
    if message:find('^RANGE_MODE_ON') then return '[CVG] TESTE DE ALCANCE ATIVO: proximo TRIAL prioriza rede de UM Pal ate 200m (experimental).'
    elseif message:find('^RANGE_MODE_OFF') then return '[CVG] TESTE DE ALCANCE DESLIGADO: TRIAL normal como antes.'
    elseif message:find('^RANGE_MODE_STATUS') then return '[CVG] ALCANCE: veja estado no log; use !cvg rangeon ou !cvg rangeoff.'
    elseif message:find('^RANGE_MODE_BLOCKED') then return '[CVG] ALCANCE: bloqueado durante possessao/recuperacao. Volte ao humano primeiro.'
    elseif message:find('^RANGE_PATCH_APPLIED') then return '[CVG] EXPERIMENTO: 1 Pal com relevancia ampliada. Distancia real no log. 3 pulos ou 40min.'
    elseif message:find('^RANGE_PATCH_FAILED') then return '[CVG] ALCANCE: nao aplicou. Retorno antecipado solicitado; veja log.'
    end
    if message:find('^CHAT_PING_OK') then return '[CVG] CHAT ATIVADO. !cvg espectar, campal, camboss, camnpc, npc, trial. Saida: 3 pulos/TXT RETURN.' end
    if message:find('^CHAT_COMMAND_BLOCKED') then return '[CVG] COMANDO BLOQUEADO: primeiro envie !cvg ping no chat.' end
    if message:find('^MSGTEST_OK') then return '[CVG] Teste de aviso privado enviado pelo Boss Control. Confirme no Xbox.' end
    if message:find('^CVG_RT_ARMED:') then return '[CVG] RT ARMADO: varias tentativas nesta posse. Cada novo aperto, no minimo 8s entre ataques. RTDISARM para desligar.' end
    if message:find('^CVG_RT_DISARMED:') then return '[CVG] RT DESARMADO. Ataque automatico pelo controle desligado.' end
    if message:find('^CVG_RT_ARM_BLOCKED:') then return '[CVG] RT NAO ARMADO: primeiro possua um Pal valido e confira o log.' end
    if message:find('^CVGSPEC_START_CALLED:') then
        return '[CVG] Camera espectador solicitada. Mova pelo menos 1m e tente CAMPAL. Xbox nao confirmado.'
    end
    if message:find('^CVGSPEC_REUSED_GAME_SPECTATE:') then
        return '[CVG] Camera espectador ja ativa. Mova 1m antes de tentar CAMPAL.'
    end
    if message:find('^CVGSPEC_BLOCKED:') or message:find('^CVGSPEC_START_FAILED:') then
        return '[CVG] CAMERA BLOQUEADA. Consulte o log; nao houve posse.'
    end
    if message:find('^CVGSPEC_END_OK:') then return '[CVG] Espectador encerrado no servidor. Confirme humano no Xbox.' end
    if message:find('^CVGSPEC_END_') then return '[CVG] Falha ou incerteza ao sair da camera. Verifique o Xbox antes de possuir.' end
    if message:find('^CAMARM_BLOCKED:') or message:find('^CAM_BLOCKED:')
       or message:find('^CAM_RETRY_NEEDS_HUMAN:') then
        return '[CVG] CAMARM bloqueado; confirme se voce esta no humano e verifique o log.'
    end
    if message:find('^CVG_HANDOFF_ABORTED:') then
        if message:find('PAWN_NOT_ORIGINAL_HUMAN',1,true) then
            return '[CVG] CAMPAL: Xbox ainda nao voltou ao humano apos sair da camera. Posse cancelada.'
        end
        if message:find('SPECTATE_FLAG',1,true) then
            return '[CVG] CAMPAL: servidor ainda registra espectador ativo. Posse cancelada.'
        end
        if message:find('PAL_AI_CONTROLLER_CHANGED',1,true) or message:find('AI_INVALID',1,true) then
            return '[CVG] CAMPAL: Pal ou IA mudou durante a transicao. Posse cancelada.'
        end
        return '[CVG] CAMPAL: falhou validacao apos camera. Posse cancelada; motivo no UE4SS.log.'
    end
    if message:find('^CVG_HANDOFF_FAILED:') or message:find('^CVG_HANDOFF_LUA_ERROR:') then
        return '[CVG] CAMPAL FALHOU: erro na transicao da camera. Confira o log; nao repita.'
    end
    if message:find('^CVG_HANDOFF_CANCELLED:') or message:find('^CVG_HANDOFF_MANUAL_CANCEL:') then
        return '[CVG] Transicao CAMPAL cancelada. Confira o controle do humano.'
    end
    if message:find('^CHECK_READY:') then return '[CVG] Pal elegivel localizado; CHECK somente leitura. Use TRIAL para tentar posse.' end
    if message:find('^CHECK_BLOCKED:') then return '[CVG] CHECK: alvo nao validado. Nenhum Pal foi possuido.' end
    if message:find('^TRIAL_UNAVAILABLE:') or message:find('^TRIAL_HANDOFF_PENDING:')
       or message:find('^TRIAL_RETRY_NEEDS_HUMAN:') then
        return '[CVG] TRIAL indisponivel: sessao/camera/recuperacao nao confirmada. Confira log.'
    end
    if message:find('^CAMPAL_TRIAL_FAILED:') or message:find('^CAMBOSS_TRIAL_FAILED:') then
        return '[CVG] Erro ao processar posse pela camera. Consulte o log; sem sucesso confirmado.'
    end
    
    if message:find('^CVG_DODGE_ARMED:') then
        return '[CVG] ESQUIVA armada no Pal atual. Aperte esquiva; o golpe so sai se o servidor confirmar a acao. Tres pulos continuam retornando.'
    end
    if message:find('^CVG_DODGE_DISARMED:') then
        return '[CVG] Ataque pela esquiva desligado. Possessao e retorno preservados.'
    end
    if message:find('^CVG_DODGE_BLOCKED:') then
        return '[CVG] Esquiva nao disponivel ou nao confirmada. Nenhum ataque disparado. Veja o UE4SS.log.'
    end
    if message:find('^CVG_BASEATTACK_RESULT:') then
        local id=message:match('pal=([%w_]+)')
        local desc=(id and pal_control.base_attack_profiles[id]) or nil
        local target=desc and (desc.name..' / '..desc.skill) or 'Pal possuido'
        if message:find('status=CHECK_OK',1,true) then
            return '[CVG] '..target..': habilidade nativa localizada. Nenhum golpe disparado.'
        end
        if message:find('status=REQUEST_SENT',1,true) then
            return '[CVG] '..target..': golpe enviado UMA vez. Confira animacao e dano no Xbox.'
        end
        if message:find('status=LUA_ERROR',1,true) then
            return '[CVG] '..target..': erro na chamada nativa. Nao repita; confira o log.'
        end
        return '[CVG] '..target..': golpe bloqueado por seguranca. Nenhum disparo solicitado; veja log.'
    end
    if message:find('^PAL_OWN_SKILLS_MANUAL_RESULT:') or message:find('^PAL_OWN_SKILL_AUTO_RESULT:') or message:find('^CVG_RT_AUTO_RESULT:') then
        if message:find('WAZA_BLOCKED',1,true) or message:find('GAME_ATTACK_ABORT',1,true) then
            return '[CVG] Ataque do Pal bloqueado com seguranca. Veja WAZA_READONLY no UE4SS.log.'
        end
        if message:find('WAZA_NATIVE_ERROR',1,true) then
            return '[CVG] Erro na tentativa de golpe nativo. Nao repita sem ler o log.'
        end
        if message:find('WAZA_ATTEMPT_DONE',1,true) then
            return '[CVG] Golpe do Pal enviado pelo servidor. Confirme animacao e efeito no Xbox.'
        end
        return '[CVG] Resultado do golpe registrado no log; confira se houve animacao no Xbox.'
    end
    if message:find('^ASTRALYM341_NATIVE_RETURN:') then
        return '[CVG] Paldium Shot solicitado ao Astralym. Confirme o efeito no Xbox.'
    end
    if message:find('^ASTRALYM341_BLOCKED:') then
        return '[CVG] Paldium Shot bloqueado; confira posse e condicoes no log.'
    end
    if message:find('^NPC_CHECK_READY') then
        return '[CVG] NPC HUMANO elegivel encontrado. Use !cvg npc (depois de !cvg ping); selecao por proximidade, nao mira.'
    end
    if message:find('^NPC_CHECK_BLOCKED') or message:find('^NPC_TRIAL_BLOCKED') then
        if message:find('alvo ambiguo',1,true) then return '[CVG] NPCs proximos demais entre si. Isole o NPC desejado e tente de novo.' end
        return '[CVG] NPC indisponivel ou inseguro. Veja no UE4SS.log; nenhum NPC foi possuido.'
    end
    if message:find('^NPC_TRIAL_SELECTED') then return '[CVG] NPC humano selecionado. Possessao em andamento; para sair use 3 pulos ou TXT RETURN.' end
    if message:find('^NPC_TRIAL_CALLED') then return '[CVG] NPC humano possuido no servidor. Chat Xbox pode fechar; para sair 3 pulos ou TXT RETURN.' end
    if message:find('^TRIAL_STAGE_3') then
        local pal=message:match('pal_class=([%w_]+)') or 'Pal Wild'
        local dist=message:match('distance_m=(%d+%.?%d*)') or '?'
        return '[CVG] Alvo '..pal..' ('..dist..'m). Sem timer na posse normal; sair com 3 pulos ou TXT RETURN.'
    end
    if message:find('^TRIAL_CALLED') then return '[CVG] Posse solicitada. Sem timer. Sair com 3 pulos em 5s ou RETURN no TXT Android.' end
    if message:find('^TRIAL_TIMEOUT_ARMED') then return '[CVG] Retorno de emergencia agendado para 40 min (se servidor permanecer ativo).' end
    if message:find('^TRIAL_TIMEOUT_RETURN') then return '[CVG] Prazo de 40 min atingido. Tentando devolver ao humano; confira controle.' end
    if message:find('^TRIAL_TIMEOUT_UNAVAILABLE') then return '[CVG] TIMER INDISPONIVEL! Retorno imediato solicitado; confira humano.' end
    if message:find('^GHOST_CLEAN_VERIFIED') then return '[CVG] CLEANUP OK: corpo antigo removido e humano verificado. TRIAL destravado!' end
    if message:find('^GHOST_CLEAN_PENDING') then return '[CVG] CLEANUP pendente: humano/corpo antigo ainda sem confirmacao; TRIAL bloqueado.' end
    if message:find('^RECOVER_OK') then return '[CVG] RECOVER: corpo antigo nao existe e humano validado. Confira movimento.' end
    if message:find('^RECOVER_BLOCKED') then return '[CVG] RECOVER BLOQUEADO: algo incerto. Veja detalhes no log.' end
    if message:find('^TRIAL_CALL_FAILED') then return '[CVG] ERRO ao invocar Possess. Verifique se voltou ao humano.' end
    if message:find('^TRIAL_FAILED') then return '[CVG] Erro Lua inesperado. Nao insista; confira registro.' end
    if message:find('^TRIAL_BUSY') then return '[CVG] Um teste ja esta sendo processado.' end
    if message:find('^TRIAL_BLOCKED') then
        if message:find('alvo ambiguo',1,true) then return '[CVG] ALVO AMBIGUO: Pals quase na mesma distancia. Aproxime do desejado.' end
        local found=message:match('found=(%d+)')
        if found then
            if found=='0' then return '[CVG] SEM PAL selvagem valido em ate 30m.' end
            return '[CVG] BLOQUEADO: '..found..' Pals proximos e sem vencedor claro. Isole o alvo.'
        end
        if message:find('owner not admin',1,true) then return '[CVG] BLOQUEADO: ative o admin no jogo.' end
        if message:find('previous trial',1,true) then return '[CVG] BLOQUEADO: possessao anterior ainda em andamento.' end
        if message:find('sample reached object cap',1,true) then return '[CVG] BLOQUEADO: muitos objetos; alvo nao confiavel.' end
        if message:find('recovery marker',1,true) then return '[CVG] BLOQUEADO apos queda/reinicio. Use !cvg status.' end
        return '[CVG] TRIAL BLOQUEADO por seguranca. Consulte o registro se precisar do detalhe.'
    end
    if message:find('^INTERACT_SYNC_RPC_SENT') then return '[CVG] Sincronizacao do humano enviada ao Xbox. Teste interagir com um bau ou bancada.' end
    if message:find('^INTERACT_SYNC_UNAVAILABLE') or message:find('^INTERACT_SYNC_FAILED') then return '[CVG] Interacao nao sincronizada. Veja UE4SS.log ou reconecte se precisar.' end
    if message:find('^INTERACT_SYNC_BLOCKED') then return '[CVG] Interacao: precisa estar no proprio humano e com admin validado.' end
    if message:find('^SKILL_TEST_SENT') then return '[CVG] Chamada de skill enviada. Confira animacao/dano no Xbox e log.' end
    if message:find('^SKILL_BLOCKED') then return '[CVG] Skill bloqueada; confirme se ainda controla seu Pal.' end
    if message:find('^SKILLCHECK_READY') then return '[CVG] Diagnostico das skills no log. Nenhum ataque foi acionado.' end
    if message:find('^JUMP_EXIT_ARMED') then return '[CVG] Detector de 3 pulos ARMADO para este Pal. E experimental.' end
    if message:find('^JUMP_EXIT_DISABLED') then return '[CVG] Retorno por pulos INDISPONIVEL. Use RETURN no TXT Android.' end
    if message:find('^RETURN_CALLED') then return '[CVG] Retorno chamado! Confira se seu humano voltou a se mover.' end
    if message:find('^RETURN_PARTIAL') then return '[CVG] RETORNO PARCIAL: humano chamado; IA do Pal nao restaurada.' end
    if message:find('^RETURN_UNCERTAIN') then return '[CVG] RETORNO INCERTO: confira controle do personagem no Xbox.' end
    if message:find('^RETURN_FAILED') then return '[CVG] FALHA NO RETORNO! Nao tente novamente sem inspecionar o servidor.' end
    if message:find('^PAL_DANGER_RESCUE_CALLED') then return '[CVG] RESGATE solicitado apos perda de Pal. Confira se voltou ao humano.' end
    if message:find('^RETURN_IDLE') then return '[CVG] Nenhuma possessao ativa.' end
    if message:find('^RETURN_BUSY') then return '[CVG] Retorno ja esta em andamento.' end
    if message:find('^RECOVERY_STATUS_SAFE') then return '[CVG] STATUS: sem pendencias conhecidas pelo mod. Copia antiga pode nao estar identificada.' end
    if message:find('^RECOVERY_STATUS_BOSS_ACTIVE') then return '[CVG] BOSS ATIVO SEM TIMER: use RETURN pelo Android ou 3 pulos/chat.' end
    if message:find('^RECOVERY_STATUS_ACTIVE') then return '[CVG] STATUS: possessao ativa. No Pal, RETURN via arquivo TXT no Android.' end
    if message:find('^RECOVERY_STATUS_OFFLINE') then return '[CVG] Aguarde humano reconectar; use !cvg status. Sem recuperacao automatica.' end
    if message:find('^RECOVERY_STATUS_GHOST') then return '[CVG] Corpo antigo possivelmente presente. Use !cvg ghost; nova possessao bloqueada.' end
    if message:find('^RECOVERY_STATUS_LOCKED') then return '[CVG] BLOQUEADO apos queda/reinicio. Se humano OK, use !cvg confirm.' end
    if message:find('^RECOVERY_WAIT_OFFLINE') then return nil end
    if message:find('^RECOVERY_RECONNECTED') then return '[CVG] Reconexao detectada. Recuperacao em verificacao; use !cvg status.' end
    if message:find('^RECOVERY_CLEAR_OK') then return '[CVG] Marcador seguro confirmado. Confira movimento no humano.' end
    if message:find('^RECOVERY_CLEAR_BLOCKED') then return '[CVG] CONFIRMACAO BLOQUEADA: nao foi possivel provar controle humano.' end
    if message:find('^REJOIN_HUMAN_VERIFIED') then return '[CVG] Humano confirmado apos reconexao. Para copia, use !cvg ghost.' end
    if message:find('^REJOIN_HUMAN_UNCERTAIN') then return '[CVG] Humano detectado, mas journal nao foi salvo. Nao repita trial.' end
    if message:find('^GHOST_NOT_TRACKED') then return '[CVG] Nenhum corpo antigo IDENTIFICADO pelo mod. Copias antigas nao podem ser apagadas com seguranca.' end
    if message:find('^GHOST_READY') then return '[CVG] Corpo ANTIGO rastreado sem controle. Se houver BACKUP, !cvg cleanup pede exclusao. RISCO ao save!' end
    if message:find('^GHOST_TRACKED') then return '[CVG] Possivel corpo antigo detectado. Use !cvg ghost. Nada foi removido.' end
    if message:find('^GHOST_BLOCKED') then return '[CVG] Corpo antigo NAO esta seguro para remocao. Consulte log.' end
    if message:find('^GHOST_CLEAN_BLOCKED') then return '[CVG] Limpeza BLOQUEADA. Use !cvg ghost e veja log. Nao houve exclusao.' end
    if message:find('^GHOST_CLEAN_CALLED') then return '[CVG] Pedido de exclusao enviado ao corpo rastreado. Verifique se sumiu. Sem garantia.' end
    if message:find('^GHOST_CLEAN_UNCERTAIN') then return '[CVG] Limpeza INCERTA. Nao repita! Consulte logs e backup.' end
    if message:find('^RECOVERY_JOURNAL_BLOCKED') then return '[CVG] Possessao bloqueada: diario de recuperacao indisponivel.' end
    if message:find('^BOSSCHECK_OK') then return '[CVG BOSS] Checagem OK. Se estiver sozinho, use !cvg bossspawn.' end
    if message:find('^BOSSCHECK_BLOCKED') then return '[CVG BOSS] Checagem bloqueada. Consulte o log; nenhum Pal criado.' end
    if message:find('^BOSSSPAWN_STARTED') then return '[CVG BOSS] Pedido enviado: Jetragon normal NV80. Verificando ator. Aguarde confirmacao.' end
    if message:find('^BOSSSPAWN_ACTOR_READY') then return '[CVG BOSS] Jetragon NV80 CRIADO no servidor. Procure a ~8m no eixo X, um pouco acima. Visibilidade Xbox nao garantida. !cvg bossenter em ate 70s.' end
    if message:find('^BOSSSPAWN_BLOCKED') then
        if message:find('cooldown',1,true) then return '[CVG BOSS] Aguarde 15s desde a limpeza confirmada; depois tente bossspawn.' end
        if message:find('previous avatar still active',1,true) then return '[CVG BOSS] Outro avatar ainda existe ou esta limpando. Use !cvg bossverify. Nao gerou outro.' end
        if message:find('previous',1,true) then return '[CVG BOSS] BLOQUEADO: registro de criacao anterior incerto. Nao insista; envie o log.' end
        return '[CVG BOSS] CRIACAO BLOQUEADA. Nenhum novo Jetragon. Envie log completo.'
    end
    if message:find('^BOSSSPAWN_FAILED') or message:find('^BOSSSPAWN_UNVERIFIED') or message:find('^BOSSSPAWN_TIMER_FAILED') then return '[CVG BOSS] FALHA na criacao ou verificacao. Nao insista; envie log.' end
    if message:find('^BOSSSPAWN_CAPTURE_GUARD_FAILED') then return '[CVG BOSS] Protecao de captura falhou. Avatar sera removido, nao possua.' end
    if message:find('^BOSS_NET_BASELINE') then return nil end
    if message:find('^BOSS_NET_PATCH_APPLIED') then return '[CVG BOSS] TESTE DE DISTANCIA ATIVO no Jetragon. Relevancia de rede ampliada; nao e garantia. Se travar, RETURN pelo Android.' end
    if message:find('^BOSS_NET_PATCH_FAILED') then return '[CVG BOSS] ERRO no ajuste de rede. Tentando devolver voce ao humano. Envie o log.' end
    if message:find('^BOSS_DISTANCE_SAMPLE') then return nil end
    if message:find('^BOSS_CLIENTSYNC_AUTO_REQUESTED') then return '[CVG BOSS] Ajuste de controle Xbox solicitado UMA VEZ ao afastar 55m. Se travar, use RETURN pelo Android.' end
    if message:find('^BOSS_CLIENTSYNC_AUTO_SKIPPED') then return nil end
    if message:find('^BOSS_NET_RESTORE') then return nil end
    if message:find('^FOCUS_DIAG') then
        local d=message:match('pal_to_human_m=([%d%.]+)') or '?'
        local f=message:match('focus_to_pal_m=([%d%.]+)') or '?'
        return '[CVG] DIAG DISTANCIA: Jetragon a '..d..'m do humano; foco a '..f..'m do Jetragon. Envie log para analise.'
    end
    if message:find('^BOSSENTER_CONTROLLED') then return '[CVG BOSS] CONTROLE CONFIRMADO pelo servidor! Sem tempo limite. Volte com !cvg return ou RETURN NNN no Android.' end
    if message:find('^BOSSENTER_BLOCKED') then
        if message:find('older than 70',1,true) then return '[CVG BOSS] TARDE DEMAIS: passaram 70s da criacao. Nao possua este avatar. Aguarde limpeza.' end
        return '[CVG BOSS] CONTROLE BLOQUEADO. Nao mudou de corpo; envie log.'
    end
    if message:find('^BOSSENTER_NATIVE_ERROR') or message:find('^BOSSENTER_UNVERIFIED') then return '[CVG BOSS] CONTROLE INCERTO! Confira seu corpo e use RETURN pelo Android se preciso.' end
    if message:find('^BOSSENTER_MANUAL_RETURN_ARMED') then return nil end
    if message:find('^BOSSRETURN_HUMAN_OK') then return '[CVG BOSS] RETORNO: humano original confirmado. Limpando avatar criado.' end
    if message:find('^BOSSRETURN_OK') then return '[CVG BOSS] RETORNO OK no servidor. Confira movimento do humano no Xbox.' end
    if message:find('^BOSSRETURN_UNCERTAIN') then return '[CVG BOSS] RETORNO INCERTO: consulte log antes de continuar.' end
    if message:find('^BOSSREMOVE_CALLED') then return '[CVG BOSS] Pedido de remover somente o avatar temporario enviado. Verificacao pendente.' end
    if message:find('^BOSSREMOVE_BLOCKED') or message:find('^BOSSREMOVE_UNCERTAIN') then return '[CVG BOSS] REMOCAO BLOQUEADA OU INCERTA. Nao crie outro. Consulte log.' end
    if message:find('^BOSSREMOVE_PENDING') then return nil end
    if message:find('^BOSSREARM_READY') then return '[CVG BOSS] Avatar anterior ausente em 2 verificacoes. Espere 15s e pode criar outro; limpeza interna total nao comprovada.' end
    if message:find('^BOSSREARM_BLOCKED') then return '[CVG BOSS] NOVO TESTE BLOQUEADO por seguranca. Envie log.' end
    if message:find('^BOSSVERIFY_READY') then return '[CVG BOSS] Nao ha avatar ativo; veja cooldown no log antes de criar outro.' end
    if message:find('^BOSSVERIFY_ACTOR_PRESENT') then return '[CVG BOSS] Avatar ainda existe no servidor, mesmo que invisivel no Xbox. Nao crie outro.' end
    if message:find('^BOSSVERIFY_ACTOR_ABSENT') then return '[CVG BOSS] Avatar nao acessivel pelo handle; limpeza completa nao provada.' end
    if message:find('^BOSSVERIFY_') then return '[CVG BOSS] Estado precisa de verificacao. Veja log.' end
    if message:find('^BOSSREMOVE_IDLE') then return '[CVG BOSS] Nenhum avatar temporario rastreado para remover.' end
    if message:find('^BOSS_JOB_BUSY') then return '[CVG BOSS] Outra operacao em andamento. Tente mais tarde.' end
    if message:find('^BOSS_COMMAND_ERROR') or message:find('^BOSS_COMMAND_BLOCKED') or message:find('^BOSS_BLOCKED') then return '[CVG BOSS] Falha ao processar comando. Consulte log; nao repita sem verificar.' end
    return nil
end
local function send_owner_chat_notice(text)
    if type(text)~='string' or #text==0 or #text>190 then return false,'invalid_text' end
    local owner=owner_guid()
    if not owner or type(FindAllOf)~='function' then return false,'owner_unavailable' end
    local owner_pc=nil
    for _,c in ipairs(FindAllOf('PalPlayerController') or {}) do
        if valid(c) and c:HasAuthority()==true and guid(c:GetPlayerUId())==owner then
            if owner_pc then return false,'multiple_owner_controllers' end
            owner_pc=c
        end
    end
    if not owner_pc then return false,'owner_offline' end
    local pc_state=owner_pc.PlayerState
    if not valid(pc_state) then return false,'player_state_unavailable' end
    local p_uid=pc_state.PlayerUId
    if guid(p_uid)~=owner then return false,'owner_guid_mismatch' end
    local okay, world=pcall(function() return FindFirstOf('World') end)
    if not okay or not valid(world) then return false,'world_unavailable' end
    if not valid(utility_cache) then
        local fetched,utility=pcall(function()return StaticFindObject('/Script/Pal.Default__PalUtility')end)
        if not fetched or not valid(utility) then return false,'palutility_unavailable' end
        utility_cache=utility
    end
    -- ExecuteInGameThread foi usado pelo chamador. Unicamente um destinatario.
    local uid_array={{A=p_uid.A,B=p_uid.B,C=p_uid.C,D=p_uid.D}}
    local sent=pcall(function()
        utility_cache:SendSystemToPlayerChat(world, text, uid_array)
    end)
    if not sent then return false,'native_delivery_lua_error' end
    -- Retorno pcall prova so invocacao, NAO confirma exibicao no Xbox.
    return true,nil
end
notice_callback=function(raw)
    local message=format_player_notice(raw)
    if not message then return end
    local success,reason=send_owner_chat_notice(message)
    if not success then
        print('[CVG Boss Control v'..VERSION..'] INGAME_NOTICE_FALLBACK: '..tostring(reason)..'; log_retained=true\n')
    end
end

local function admin_diagnostic()
    local owner, issue=owner_guid()
    if not owner then log('ADMIN_CHECK_BLOCKED: '..issue);return end
    if type(FindAllOf)~='function' then log('ADMIN_CHECK_BLOCKED: FindAllOf unavailable');return end
    local ok,found,admins=pcall(function()
        local matched, count = nil,0
        -- Scan apenas dos poucos PlayerControllers, NUNCA Pals/NPCs.
        for _, pc in ipairs(FindAllOf('PalPlayerController') or {}) do
            if valid(pc) and pc:HasAuthority()==true then
                if pc.bAdmin==true then count=count+1 end
                if guid(pc:GetPlayerUId())==owner then
                    if matched~=nil then error('duplicate owner controller') end
                    matched = pc.bAdmin==true
                end
            end
        end
        return matched,count
    end)
    if not ok then log('ADMIN_CHECK_FAILED: controller diagnostic errored');return end
    log('ADMIN_CHECK_OK: owner_online='..tostring(found~=nil)..
        '; owner_admin='..tostring(found==true)..'; admin_count='..tostring(admins))
end

-- Amostragem MINIMA: nenhum Pal/NPC e procurado; NAO usa LineTraceSingle.
-- Testa unicamente se o servidor enxerga a rotacao do controle do dono.
local function normalize_angle(n)
    if type(n)~='number' or n~=n or math.abs(n)>100000 then return nil end
    local wrapped=(n+180)%360-180
    return math.floor(wrapped+0.5)
end
-- v1.2: sem arredondamento dos graus para a geometria de alvos. VIEW/AIM antigos
-- continuam intactos; a alteracao e apenas no calculo CHECK/TRIAL.
local function normalize_angle_precise(n)
    if type(n)~='number' or n~=n or math.abs(n)>100000 then return nil end
    return (n+180)%360-180
end
local function view_diagnostic()
    local expected,issue=owner_guid()
    if not expected then log('VIEW_BLOCKED: '..issue);return end
    if type(FindAllOf)~='function' then log('VIEW_BLOCKED: controller API unavailable');return end
    log('VIEW_STAGE_1: finding only owner PlayerController (no NPCs)')
    local success, result=pcall(function()
        local pc, admins=nil,0
        for _, candidate in ipairs(FindAllOf('PalPlayerController') or {}) do
            if valid(candidate) and candidate:HasAuthority()==true then
                if candidate.bAdmin==true then admins=admins+1 end
                if guid(candidate:GetPlayerUId())==expected then
                    if pc~=nil then error('duplicate owner PlayerController') end
                    pc=candidate
                end
            end
        end
        if pc==nil then return 'VIEW_BLOCKED: owner offline or controller not found' end
        if pc.bAdmin~=true then return 'VIEW_BLOCKED: owner not authenticated as admin' end
        if admins~=1 then return 'VIEW_BLOCKED: expected exactly one admin controller' end
        log('VIEW_STAGE_2: read-only GetControlRotation on owner controller')
        local rotation=pc:GetControlRotation()
        if rotation==nil then return 'VIEW_BLOCKED: server rotation unavailable' end
        local yaw=normalize_angle(rotation.Yaw)
        local pitch=normalize_angle(rotation.Pitch)
        if yaw==nil or pitch==nil then return 'VIEW_BLOCKED: rotation not numeric/valid' end
        return 'VIEW_OK: controller_yaw_deg='..yaw..'; controller_pitch_deg='..pitch..'; xbox_aim_not_yet_proven=true; no_actors_modified=true'
    end)
    if success then log(result)
    else log('VIEW_FAILED: read-only controller inspection raised an error') end
end

-- Geometria LOCAL, sem traco na Unreal nem varredura de atores.
local function num_in_range(n,max_abs)
    return type(n)=='number' and n==n and math.abs(n)<=max_abs
end
local function aim_or_origin_diagnostic(action)
    local expected,issue=owner_guid()
    if not expected then log(action..'_BLOCKED: '..issue);return end
    if type(FindAllOf)~='function' then log(action..'_BLOCKED: player controller API unavailable');return end
    log(action..'_STAGE_1: finding owner controller only (no NPCs)')
    local success,result=pcall(function()
        local pc,admins=nil,0
        for _,candidate in ipairs(FindAllOf('PalPlayerController') or {}) do
            if valid(candidate) and candidate:HasAuthority()==true then
                if candidate.bAdmin==true then admins=admins+1 end
                if guid(candidate:GetPlayerUId())==expected then
                    if pc~=nil then error('duplicate owner controller') end
                    pc=candidate
                end
            end
        end
        if pc==nil then return action..'_BLOCKED: owner offline or controller not found' end
        if pc.bAdmin~=true then return action..'_BLOCKED: owner not authenticated as admin' end
        if admins~=1 then return action..'_BLOCKED: expected exactly one admin' end
        log(action..'_STAGE_2: read-only GetControlRotation on owner')
        local rotation=pc:GetControlRotation()
        if rotation==nil then return action..'_BLOCKED: no control rotation' end
        local yaw=normalize_angle(rotation.Yaw)
        local pitch=normalize_angle(rotation.Pitch)
        if yaw==nil or pitch==nil then return action..'_BLOCKED: rotation not valid' end
        local yr,pr=math.rad(yaw),math.rad(pitch)
        local fx=math.cos(pr)*math.cos(yr)
        local fy=math.cos(pr)*math.sin(yr)
        local fz=math.sin(pr)
        if not(num_in_range(fx,1.00001) and num_in_range(fy,1.00001) and num_in_range(fz,1.00001)) then
            return action..'_BLOCKED: math vector invalid'
        end
        if action=='AIM' then
            return string.format('AIM_OK: yaw_deg=%d; pitch_deg=%d; math_forward_x=%.3f; math_forward_y=%.3f; math_forward_z=%.3f; hypothetical_distance_m=10; no_raytrace=true; xbox_reticle_not_proven=true; no_actors_modified=true',yaw,pitch,fx,fy,fz)
        end
        -- ORIGIN APENAS: chamada extra em pawn do dono, nunca em Pal selvagem.
        log('ORIGIN_STAGE_3: read-only K2_GetPawn on owner controller')
        local pawn=pc:K2_GetPawn()
        if not valid(pawn) then return 'ORIGIN_BLOCKED: owner pawn not valid' end
        if pawn:HasAuthority()~=true then return 'ORIGIN_BLOCKED: pawn lacks server authority' end
        log('ORIGIN_STAGE_4: read-only K2_GetActorLocation on owner pawn')
        local pos=pawn:K2_GetActorLocation()
        if pos==nil then return 'ORIGIN_BLOCKED: pawn position unavailable' end
        local x,y,z=pos.X,pos.Y,pos.Z
        if not(num_in_range(x,100000000) and num_in_range(y,100000000) and num_in_range(z,100000000)) then
            return 'ORIGIN_BLOCKED: pawn position invalid'
        end
        local model_x,model_y,model_z=x+1000*fx,y+1000*fy,z+1000*fz
        if not(num_in_range(model_x,100001000) and num_in_range(model_y,100001000) and num_in_range(model_z,100001000)) then
            return 'ORIGIN_BLOCKED: projected point invalid'
        end
        local delta='first_reading'
        if previous_origin then
            local dx,dy,dz=x-previous_origin[1],y-previous_origin[2],z-previous_origin[3]
            local displacement=math.sqrt(dx*dx+dy*dy+dz*dz)/100
            if not num_in_range(displacement,10000000) then return 'ORIGIN_BLOCKED: displacement invalid' end
            delta=string.format('%.1f',displacement)
        end
        previous_origin={x,y,z}
        return string.format('ORIGIN_OK: owner_pawn_valid=true; pawn_position_valid=true; math_endpoint_10m_valid=true; distance_from_previous_m=%s; coordinates_redacted=true; no_NPC_scans=true; no_raytrace=true; no_actors_modified=true',delta)
    end)
    if success then log(result)
    else log(action..'_FAILED: read-only diagnostic raised an error (no details logged)') end
end

-- NEAR e executado UMA VEZ apenas quando solicitado via arquivo privado,
-- NUNCA no LoopAsync automatico. Nenhum ponteiro de Pal e guardado.
-- FindObjects amostra os 128 primeiros objetos que combinam com PalCharacter;
-- NAO e busca espacial exaustiva, e pode nao encontrar Pals proximos.
-- Refletir objetos pode causar falha nativa mesmo com pcall. Teste supervisionado.
local function near_diagnostic()
    local expected,issue=owner_guid()
    if not expected then log('NEAR_BLOCKED: '..issue);return end
    if type(FindAllOf)~='function' or type(FindObjects)~='function' then
        log('NEAR_BLOCKED: bounded UE4SS enumeration API unavailable');return
    end
    if EObjectFlags==nil or EObjectFlags.RF_NoFlags==nil or
       EObjectFlags.RF_ClassDefaultObject==nil then
        log('NEAR_BLOCKED: UE4SS EObjectFlags unavailable');return
    end
    log('NEAR_STAGE_1: authenticating only owner controller')
    local success,result=pcall(function()
        local pc,admins=nil,0
        for _,candidate in ipairs(FindAllOf('PalPlayerController') or {}) do
            if valid(candidate) and candidate:HasAuthority()==true then
                if candidate.bAdmin==true then admins=admins+1 end
                if guid(candidate:GetPlayerUId())==expected then
                    if pc~=nil then error('duplicate owner controller') end
                    pc=candidate
                end
            end
        end
        if pc==nil then return 'NEAR_BLOCKED: owner offline or controller not found' end
        if pc.bAdmin~=true then return 'NEAR_BLOCKED: owner not authenticated as admin' end
        if admins~=1 then return 'NEAR_BLOCKED: exactly one admin required' end
        log('NEAR_STAGE_2: reading owner pawn location and controller rotation')
        local pawn=pc:K2_GetPawn()
        if not valid(pawn) or pawn:HasAuthority()~=true then
            return 'NEAR_BLOCKED: owner pawn invalid or lacks authority'
        end
        local origin=pawn:K2_GetActorLocation()
        local rotation=pc:GetControlRotation()
        if origin==nil or rotation==nil then return 'NEAR_BLOCKED: owner geometry unavailable' end
        local x,y,z=origin.X,origin.Y,origin.Z
        local yaw=normalize_angle(rotation.Yaw)
        local pitch=normalize_angle(rotation.Pitch)
        if not(num_in_range(x,100000000) and num_in_range(y,100000000) and
               num_in_range(z,100000000) and yaw~=nil and pitch~=nil) then
            return 'NEAR_BLOCKED: owner geometry invalid'
        end
        local yr,pr=math.rad(yaw),math.rad(pitch)
        local fx=math.cos(pr)*math.cos(yr)
        local fy=math.cos(pr)*math.sin(yr)
        local fz=math.sin(pr)
        if not(num_in_range(fx,1.00001) and num_in_range(fy,1.00001) and
               num_in_range(fz,1.00001)) then
            return 'NEAR_BLOCKED: owner direction invalid'
        end
        -- Intervalo para evitar varreduras repetidas do GUObjectArray.
        local now=os.time()
        if type(now)~='number' then return 'NEAR_BLOCKED: cooldown clock unavailable' end
        if last_near_scan_ts~=nil then
            local elapsed=now-last_near_scan_ts
            if elapsed<NEAR_COOLDOWN_SECONDS then
                return 'NEAR_BLOCKED: cooldown active; wait at least 45 seconds between scans'
            end
        end
        last_near_scan_ts=now
        log('NEAR_STAGE_3: sampling up to 128 PalCharacter objects once (not exhaustive)')
        -- Zero required flags; exclude ClassDefaultObject; allow subclasses.
        -- This is safer than an unlimited FindAllOf("PalCharacter") scan.
        local pals=FindObjects(NEAR_SCAN_LIMIT,'PalCharacter',nil,
            EObjectFlags.RF_NoFlags,EObjectFlags.RF_ClassDefaultObject,false)
        if pals==nil then
            return 'NEAR_OK: sample_size=0; near_15m=0; wild_near_15m=0; no_actor_modified=true; sample_not_exhaustive=true'
        end
        local sample_size=math.min(#pals,NEAR_SCAN_LIMIT)
        local location_ok,near_all,wild_near,wild_in_cone=0,0,0,0
        local closest_any,closest_wild=nil,nil
        local inspected=0
        for _,actor in ipairs(pals) do
            inspected=inspected+1
            if inspected>NEAR_SCAN_LIMIT then break end
            -- Erros de reflexao da instancia sao tratados separadamente.
            -- Nao alteramos Controller, Pawn, AI, camera, instigador, dono ou HP.
            local ok,entry=pcall(function()
                if not valid(actor) or actor:HasAuthority()~=true then return nil end
                local cls=actor:GetClass()
                if not valid(cls) then return nil end
                local cls_name=cls:GetFName():ToString()
                if type(cls_name)~='string' then return nil end
                if cls_name:lower():find('player',1,true) then return nil end
                local pos=actor:K2_GetActorLocation()
                if pos==nil then return nil end
                local ax,ay,az=pos.X,pos.Y,pos.Z
                if not(num_in_range(ax,100000000) and num_in_range(ay,100000000)
                    and num_in_range(az,100000000)) then return nil end
                local dx,dy,dz=ax-x,ay-y,az-z
                local dist=math.sqrt(dx*dx+dy*dy+dz*dz)
                if not num_in_range(dist,200000000) or dist<=1 then return nil end
                local is_wild=false
                local controller=actor.Controller
                if valid(controller) then
                    local controller_cls=controller:GetClass()
                    if valid(controller_cls) then
                        local controller_cls_name=controller_cls:GetFName():ToString()
                        if type(controller_cls_name)=='string' and
                           controller_cls_name:find('Wild',1,true) then
                            is_wild=true
                        end
                    end
                end
                local dot=(dx*fx+dy*fy+dz*fz)/dist
                if not num_in_range(dot,1.00001) then return nil end
                dot=math.max(-1,math.min(1,dot))
                return {distance=dist,wild=is_wild,in_cone=dot>=math.cos(math.rad(25))}
            end)
            if ok and entry then
                location_ok=location_ok+1
                if entry.distance<=NEAR_RADIUS_CM then
                    near_all=near_all+1
                    if closest_any==nil or entry.distance<closest_any then
                        closest_any=entry.distance
                    end
                    if entry.wild then
                        wild_near=wild_near+1
                        if closest_wild==nil or entry.distance<closest_wild then
                            closest_wild=entry.distance
                        end
                        if entry.in_cone then wild_in_cone=wild_in_cone+1 end
                    end
                end
            end
        end
        local any_m=closest_any and string.format('%.1f',closest_any/100) or 'none'
        local wild_m=closest_wild and string.format('%.1f',closest_wild/100) or 'none'
        return string.format('NEAR_OK: sample_size=%d; readable_nonplayer=%d; near_15m=%d; closest_pal_m=%s; wild_near_15m=%d; wild_in_25deg_cone=%d; closest_wild_m=%s; wild_filter=AI_controller_name_heuristic; sample_not_exhaustive=true; xbox_reticle_not_proven=true; no_raytrace=true; no_actors_modified=true',
            sample_size,location_ok,near_all,any_m,wild_near,wild_in_cone,wild_m)
    end)
    if success then log(result)
    else log('NEAR_FAILED: bounded diagnostic failed; no exception details or coordinates logged') end
end

-- TRIAL: Possess repetivel APENAS apos retorno confirmado, no game thread.
-- Mutacao real: muda o controlador do Pawn. Se o native crashar, pcall NAO salva.
-- Somente owner GUID + bAdmin=true; permite outros jogadores, mas nunca outro owner.
-- Nao ha garantia de compatibilidade com client Xbox ou de persistencia do Pawn humano.
local function owner_and_count()
    local expected,issue=owner_guid()
    if not expected then return nil,0,'owner credential invalid' end
    local player_count,owner_pc=0,nil
    for _,candidate in ipairs(FindAllOf('PalPlayerController') or {}) do
        if valid(candidate) and candidate:HasAuthority()==true then
            player_count=player_count+1
            if guid(candidate:GetPlayerUId())==expected then
                if owner_pc~=nil then return nil,player_count,'duplicate owner controller' end
                owner_pc=candidate
            end
        end
    end
    if owner_pc==nil then return nil,player_count,'owner offline' end
    if owner_pc.bAdmin~=true then return nil,player_count,'owner not admin' end
    return owner_pc,player_count,nil
end
-- Restaurar PROPRIEDADES ORIGINAIS do mesmo Pal (nao reaplicar em outros atores).
-- Em desconexao/captura, a referencia pode nao existir. Nao insistir sobre invalido.
local function range_restore_actor(state)
    if not state or not state.range_applied then return end
    state.range_applied=false -- nao repetir chamada caso restauracao fique incerta
    if not state.range_original or not valid(state.pal) then
        log('RANGE_RESTORE_SKIPPED: Pal unavailable; no writes to stale object')
        return
    end
    local ok_cull=pcall(function()state.pal.NetCullDistanceSquared=state.range_original.cull end)
    local ok_always=pcall(function()state.pal.bAlwaysRelevant=state.range_original.always end)
    if ok_cull and ok_always then log('RANGE_RESTORE_OK: original Pal network properties restored')
    else log('RANGE_RESTORE_UNCERTAIN: native property write failed; manual inspection before repeat') end
end
-- AI v1.9.3: somente o controller Wild ORIGINAL do unico Pal rastreado.
-- BrainComponent e UFUNCTION variam conforme build; falhar fechado SEM inventar APIs.
local function tracked_brain(ai)
    if not valid(ai) then return nil end
    local ok,b=pcall(function()return ai.BrainComponent end)
    if ok and valid(b) then return b end
    ok,b=pcall(function()return ai:GetBrainComponent()end)
    if ok and valid(b) then return b end
    return nil
end
local function brain_read(brain)
    if not valid(brain) then return nil,nil end
    local ok,r=pcall(function()return brain:IsRunning()end)
    local ok2,p=pcall(function()return brain:IsPaused()end)
    if not ok or type(r)~='boolean' then r=nil end
    if not ok2 or type(p)~='boolean' then p=nil end
    return r,p
end
-- Palworld custom controller API: native AI activation is NOT UE BrainComponent.
-- Snapshot is read-only; no broad actor scan. Method may be absent in a game update.
local function native_pal_ai_active(ai)
    if not valid(ai) then return nil end
    local ok,active=pcall(function() return ai:IsActiveAI() end)
    if ok and type(active)=='boolean' then return active end
    return nil
end
local function native_pal_action_snapshot(ai)
    if not valid(ai) then return nil,nil,nil end
    local ok,component=pcall(function() return ai:GetAIActionComponent() end)
    if not ok or not valid(component) then
        ok,component=pcall(function() return ai.AIActionComponent end)
    end
    if not ok or not valid(component) then return false,nil,nil end
    local can_read,empty=pcall(function() return component:IsActionEmpty() end)
    if not can_read or type(empty)~='boolean' then empty=nil end
    local action_read,action=pcall(function() return component:GetCurrentAction_BP() end)
    local has_action=nil
    if action_read then has_action=valid(action) end
    return true,empty,has_action
end
local function wild_ai_controls_tracked_pal(state)
    if not state or state.offline or state.pal_lost or not valid(state.ai) or not valid(state.pal) then return false end
    local original_ai_key=state.ai_key
    local original_pal_key=state.pal_key
    if not original_ai_key or actor_key(state.ai)~=original_ai_key or
       not original_pal_key or actor_key(state.pal)~=original_pal_key then return false end
    local ok,current=pcall(function()return state.pal.Controller end)
    if not ok or not valid(current) or actor_key(current)~=original_ai_key then return false end
    -- Adicional: quando disponivel, confirmar Pawn do AI sem depender de ponteiros Lua iguais.
    local read,pawn=pcall(function()return state.ai:K2_GetPawn()end)
    if read and valid(pawn) and actor_key(pawn)~=original_pal_key then return false end
    return true
end
local function human_still_controls_original(state)
    if not state or not state.pc_key or not valid(state.pc) or actor_key(state.pc)~=state.pc_key then return false end
    local ok,pawn=pcall(function() return state.pc:K2_GetPawn() end)
    return ok and valid(pawn) and actor_key(pawn)==state.human_key and
        pawn_matches_human(pawn,state.human_class)
end

-- v1.10.5: protecao de captura de UM Pal selvagem original durante a possessao.
-- Campos publicados na SDK do jogo: individual.bIsUncapturable,
-- individual.bIsForceCapturable e static.IsUncapturable.
-- Nao altera especie, dano, habilidades, save, outros Pals ou NPCs humanos.
-- 'armed' so significa readback no servidor, nao sucesso de esfera no Xbox.
local capture_guard={}
function capture_guard.snapshot(pal)
    if not valid(pal) or not actor_key(pal) or pal_control.target_kind(pal)~='PAL' then
        return nil,'target_not_live_wild_pal'
    end
    local ok,component,individual,static=pcall(function()
        local c=pal.CharacterParameterComponent
        if not valid(c) then return nil,nil,nil end
        local read,i=pcall(function() return c:GetIndividualParameter() end)
        if not read or not valid(i) then i=c.IndividualParameter end
        return c,i,pal.StaticCharacterParameterComponent
    end)
    if not ok or not valid(component) or not valid(individual) or not valid(static) then
        return nil,'capture_components_unavailable'
    end
    local ok2,unc,force,sunc=pcall(function()
        return individual.bIsUncapturable, individual.bIsForceCapturable, static.IsUncapturable
    end)
    if not ok2 or type(unc)~='boolean' or type(force)~='boolean' or type(sunc)~='boolean' then
        return nil,'capture_flags_baseline_unreadable'
    end
    local snap={pal_key=actor_key(pal),component=component,component_key=actor_key(component),
        individual=individual,individual_key=actor_key(individual),
        static=static,static_key=actor_key(static),
        unc=unc,force=force,sunc=sunc, changed=false,armed=false}
    if not snap.component_key or not snap.individual_key or not snap.static_key then
        return nil,'capture_native_identity_unavailable'
    end
    return snap
end
function capture_guard.exact(state)
    local g=state and state.capture_guard
    if not g or not valid(state.pal) or actor_key(state.pal)~=g.pal_key or
        not valid(g.component) or actor_key(g.component)~=g.component_key or
        not valid(g.individual) or actor_key(g.individual)~=g.individual_key or
        not valid(g.static) or actor_key(g.static)~=g.static_key then return false end
    local ok,component,individual,static=pcall(function()
        local c=state.pal.CharacterParameterComponent
        if not valid(c) then return nil,nil,nil end
        local read,i=pcall(function() return c:GetIndividualParameter() end)
        if not read or not valid(i) then i=c.IndividualParameter end
        return c,i,state.pal.StaticCharacterParameterComponent
    end)
    return ok and valid(component) and actor_key(component)==g.component_key and
        valid(individual) and actor_key(individual)==g.individual_key and
        valid(static) and actor_key(static)==g.static_key
end
function capture_guard.flags(g)
    local ok,unc,force,sunc=pcall(function()
        return g.individual.bIsUncapturable,g.individual.bIsForceCapturable,g.static.IsUncapturable
    end)
    if not ok or type(unc)~='boolean' or type(force)~='boolean' or type(sunc)~='boolean' then
        return nil,nil,nil
    end
    return unc,force,sunc
end
function capture_guard.apply(state)
    if not state or state.target_kind~='PAL' or not state.capture_guard or
        trial~=state or not pal_control.exact(state,false) or
        not human_still_controls_original(state) or
        not wild_ai_controls_tracked_pal(state) or not capture_guard.exact(state) then
        return false,'identity_or_prepossess_state_changed'
    end
    local g=state.capture_guard
    local unc,force,sunc=capture_guard.flags(g)
    if unc~=g.unc or force~=g.force or sunc~=g.sunc then
        return false,'capture_baseline_changed_externally'
    end
    g.changed=true  -- ANTES da primeira mutacao; reversao se qualquer passo falhar
    local ok=pcall(function()
        g.individual:SetForceCapturable(false)
        g.individual:SetUncapturable(true)
        g.static.IsUncapturable=true
    end)
    local a,b,c=capture_guard.flags(g)
    if not ok or a~=true or b~=false or c~=true then
        log('CAPTURE_GUARD_ARM_FAILED: native_setter_or_readback_failed; undo_required_before_next_trial')
        return false,'capture_protection_not_verified'
    end
    g.armed=true
    log('CAPTURE_GUARD_ARMED: exact_original_wild_pal=true; individual_uncapturable=true; force_capturable=false; static_uncapturable=true; server_readback=true; no_absolute_capture_guarantee')
    return true
end
function capture_guard.restore(state)
    local g=state and state.capture_guard
    if not g or not g.changed then return true end  -- NPCs nao sao modificados
    if state.pal_lost then
        -- Ator morto/capturado: nunca tocar UObject liberado. Nao ha Pal
        -- original utilizavel para capturar depois; nao afirmar restauracao.
        log('CAPTURE_GUARD_TARGET_LOST: dead_or_captured; no_native_write_to_lost_target; restoration_unverified')
        return true
    end
    if not capture_guard.exact(state) then
        log('CAPTURE_GUARD_RESTORE_BLOCKED: original Pal/parameter identity changed; journal remains ACTIVE')
        return false
    end
    -- Validar humano original; se ainda possuindo Pal, NUNCA tornar capturavel.
    if not human_still_controls_original(state) then
        log('CAPTURE_GUARD_RESTORE_BLOCKED: original human not controlled; Pal remains protected')
        return false
    end
    local unc,force,sunc=capture_guard.flags(g)
    if (g.armed and (unc~=true or force~=false or sunc~=true)) or
       (not g.armed and not ((unc==g.unc or unc==true) and
        (force==g.force or force==false) and (sunc==g.sunc or sunc==true))) then
        log('CAPTURE_GUARD_RESTORE_BLOCKED: capture flags externally changed; no overwrite')
        return false
    end
    local ok=pcall(function()
        -- Partial arm can fail before all setters finish; only restore fields
        -- that actually changed. This also handles unavailable setters.
        if unc~=g.unc then g.individual:SetUncapturable(g.unc) end
        if force~=g.force then g.individual:SetForceCapturable(g.force) end
        if sunc~=g.sunc then g.static.IsUncapturable=g.sunc end
    end)
    local a,b,c=capture_guard.flags(g)
    if not ok or a~=g.unc or b~=g.force or c~=g.sunc then
        log('CAPTURE_GUARD_RESTORE_FAILED: exact original values not confirmed; retry RETURN; no SAFE journal')
        return false
    end
    g.changed=false;g.armed=false
    log('CAPTURE_GUARD_RESTORED: exact_original_wild_pal=true; all_3_original_capture_flags_restored=true; normal_capture_rules_resumed; no_other_actor_modified=true')
    return true
end

-- V1.9.4: no Unreal PawnAction pode existir mesmo com IsActiveAI=false.
-- Capturar APENAS referencias a composites ja existentes, nunca criar uma nova arvore.
-- Prioridades EAIRequestPriority: SoftScript=0, Logic=1, HardScript=2,
-- Reaction=3, Ultimate=4 (AIModule). O getter pode nao estar exposto.
local function get_native_ai_component(ai)
    if not valid(ai) then return nil end
    local ok,c=pcall(function() return ai:GetAIActionComponent() end)
    if ok and valid(c) then return c end
    ok,c=pcall(function() return ai.AIActionComponent end)
    if ok and valid(c) then return c end
    return nil
end
local function action_roots_snapshot(component)
    local roots={}
    if not valid(component) then return roots end
    for priority=0,4 do
        local ok,root=pcall(function() return component:GetCompositeRoot(priority) end)
        if ok and valid(root) then
            -- Root must identify its original component. If UE method is not
            -- readable we can DIAGNOSE but must NEVER install unknown roots.
            local own,owner=pcall(function() return root:GetOwnerComponent() end)
            if own and valid(owner) and actor_key(owner)==actor_key(component) then
                roots[priority]={ref=root,key=actor_key(root)}
            end
        end
    end
    return roots
end
local function root_count(roots)
    local n=0
    for _,entry in pairs(roots or {}) do if entry and entry.key then n=n+1 end end
    return n
end
-- v1.10.0: 'reinicio local' limitado ao componente do MESMO Pal, SEM
-- respawn/destruicao ou substituicao de controller. Reaplica root MESMO
-- quando continua registrado, pois v1.9.4 encontrou root=1, action=0.
-- SetRootComposite NAO e API comprovada de Restart; log deve dizer somente
-- que re-registration foi invocada e que o estado final sera verificado.
local function repair_missing_ai_actions(state,component)
    if state.action_repair_attempted then return false,'already_attempted' end
    state.action_repair_attempted=true
    if not valid(component) or not state.ai_component_key or
       actor_key(component)~=state.ai_component_key then return false,'component_identity_changed' end
    if not wild_ai_controls_tracked_pal(state) or not human_still_controls_original(state) then
        return false,'controller_or_human_changed'
    end
    local roots=state.ai_roots or {}
    -- Validate the *entire* original root set before any native mutation.
    -- If another system installed a different root, abort without writing.
    local operations={}
    for priority=0,4 do
        local entry=roots[priority]
        if entry then
            if not valid(entry.ref) or actor_key(entry.ref)~=entry.key then
                return false,'original_root_invalid'
            end
            local own,owner=pcall(function() return entry.ref:GetOwnerComponent() end)
            if not own or not valid(owner) or actor_key(owner)~=state.ai_component_key then
                return false,'root_owner_changed'
            end
            local ok,current=pcall(function() return component:GetCompositeRoot(priority) end)
            if not ok then return false,'root_getter_unavailable' end
            local mode
            if not valid(current) then
                mode='restore_missing'
            elseif actor_key(current)==entry.key then
                mode='reapply_same'
            else
                return false,'root_changed_by_game'
            end
            operations[#operations+1]={priority=priority,ref=entry.ref,key=entry.key,mode=mode}
        end
    end
    -- Native action stack was absent; first let Palworld refresh its controlled
    -- pawn. The call can itself restore an action; avoid additional mutations then.
    local recache=pcall(function() component:CacheControlledPawn_BP() end)
    log('AI_ACTION_PAWN_RECACHE: called='..tostring(recache)..'; exact_component=true; behavior_not_verified=true')
    if not recache then return false,'recache_api_unavailable' end
    local _,post_empty,post_action=native_pal_action_snapshot(state.ai)
    if post_action==true and post_empty~=true then
        log('AI_ONEPAL_RESET_SKIPPED: original action recovered by recache; no root rebind')
        return true,'recache=true; roots_restored=0; roots_reapplied=0; native_action_reappeared=true'
    end
    if #operations==0 then
        return false,'no_original_composite_roots_to_rebind'
    end
    local restored,reapplied=0,0
    for _,op in ipairs(operations) do
        if not valid(component) or actor_key(component)~=state.ai_component_key or
           not wild_ai_controls_tracked_pal(state) or not human_still_controls_original(state) then
            return false,'original_identity_changed_before_root_rebind'
        end
        if not valid(op.ref) or actor_key(op.ref)~=op.key then
            return false,'saved_original_root_invalid_before_native_call'
        end
        local owns,owner=pcall(function() return op.ref:GetOwnerComponent() end)
        if not owns or not valid(owner) or actor_key(owner)~=state.ai_component_key then
            return false,'root_owner_changed_before_native_call'
        end
        -- Read-only trace: whether the original root still has its Pawn,
        -- controller, and child chain after the player stops possessing it.
        local paused_ok,paused=pcall(function() return op.ref:IsPaused() end)
        local child_ok,child=pcall(function() return op.ref:GetChild() end)
        local pawn_ok,root_pawn=pcall(function() return op.ref:GetPawn() end)
        local ctrl_ok,root_ctrl=pcall(function() return op.ref:GetController() end)
        log('AI_ONEPAL_RESET_ROOT_DIAG: priority='..op.priority..'; mode='..op.mode..
            '; paused='..tostring(paused_ok and paused or nil)..
            '; child_present='..tostring(child_ok and valid(child))..
            '; pawn_is_original='..tostring(pawn_ok and valid(root_pawn) and actor_key(root_pawn)==state.pal_key)..
            '; controller_is_original='..tostring(ctrl_ok and valid(root_ctrl) and actor_key(root_ctrl)==state.ai_key)..
            '; read_only=true')
        local read,current=pcall(function() return component:GetCompositeRoot(op.priority) end)
        if not read then return false,'root_changed_before_call_unreadable' end
        if op.mode=='reapply_same' and (not valid(current) or actor_key(current)~=actor_key(op.ref)) then
            return false,'root_changed_before_reapply'
        end
        if op.mode=='restore_missing' and valid(current) then
            return false,'root_changed_before_restore'
        end
        -- One call per original root; NEVER clear current root, stop another
        -- character's AI, spawn a controller or recreate the Pal actor.
        local called=pcall(function() component:SetRootComposite(op.ref,op.priority) end)
        if op.mode=='reapply_same' then
            log('AI_ONEPAL_RESET_REAPPLY: priority='..op.priority..'; called='..tostring(called)..'; same_original_root=true; restart_NOT_verified=true')
            reapplied=reapplied+1
        else
            log('AI_ACTION_ROOT_RESTORE: priority='..op.priority..'; called='..tostring(called)..'; same_original_root=true')
            restored=restored+1
        end
        if not called then return false,'native_set_root_error' end
    end
    log('AI_ONEPAL_RESET_CALLED: same_Pal=true; original_controller=true; component_unchanged=true; roots_reapplied='..reapplied..'; roots_restored='..restored..'; BEHAVIOR_NOT_VERIFIED')
    return true,'recache=true; roots_restored='..restored..'; roots_reapplied='..reapplied
end
-- V1.9.4: Palworld usa APalAIController.IsActiveAI / SetActiveAI,
-- distinto de Unreal BrainComponent. Nao fabricar estados ou reiniciar todo o mundo.
-- Reativar APENAS se o mesmo controlador Wild estava ativo ANTES e passou a
-- inativo DEPOIS. Uma chamada por TRIAL, checagem novamente apos 900 ms.
local function schedule_ai_postcheck(state)
    if not state or not state.ai_key or not state.human_key then
        ai_recovery_uncertain=true
        log('AI_POSTCHECK_UNAVAILABLE: original identities missing; new trials blocked')
        return
    end
    ai_postcheck_pending=true
    local ok=pcall(function()
        ExecuteWithDelay(AI_POSTCHECK_DELAY_MS,function()
            local dispatch=pcall(function()
                ExecuteInGameThread(function()
                    local function block(message)
                        ai_postcheck_pending=false
                        ai_recovery_uncertain=true
                        log(message..'; new trials blocked')
                    end
                    if trial~=nil or not human_still_controls_original(state) then
                        block('AI_POSTCHECK_BLOCKED: original human owner changed')
                        return
                    end
                    if not valid(state.pal) then
                        -- Pode ter ocorrido despawn natural. Nao tocar em ator removido.
                        ai_postcheck_pending=false
                        log('AI_POSTCHECK_SKIPPED: original Pal despawned; no native call')
                        return
                    end
                    if not wild_ai_controls_tracked_pal(state) then
                        block('AI_POSTCHECK_FAILED: original Wild controller not on original Pal')
                        return
                    end
                    local active=native_pal_ai_active(state.ai)
                    local component_present,action_empty,action_present=native_pal_action_snapshot(state.ai)
                    log('AI_NATIVE_POSTCHECK: baseline_active='..tostring(state.pal_ai_was_active)..'; current_active='..tostring(active)..
                        '; component_present='..tostring(component_present)..'; action_empty='..tostring(action_empty)..
                        '; action_present='..tostring(action_present)..'; same_wild=true; read_only=true')
                    -- Any baseline action disappearing is a failure, EVEN IF
                    -- IsActiveAI was false both before and after (observed CVG2).
                    local lost_action=(state.pal_ai_action_present==true and action_present~=true) or
                        (state.pal_ai_action_empty==false and action_empty==true)
                    if lost_action and state.pal_ai_was_active==false and active==false then
                        -- CVG 1.10.1: a acao atual pode acabar naturalmente durante
                        -- a troca de controller. O log real mostrou IsActiveAI=false
                        -- ANTES e DEPOIS; SetRootComposite nao comprovou reativar
                        -- nada. Nao fabricar SetActiveAI(true) nem bloquear o mundo.
                        -- Duas leituras + identidade exata do humano e Wild AI.
                        log('AI_IDLE_ACTION_RECHECK_ARMED: native_active_same_false=true; transient_action_missing=true; no_native_mutation=true')
                        local scheduled=pcall(function()
                            ExecuteWithDelay(AI_FINALCHECK_DELAY_MS,function()
                                local dispatched=pcall(function()
                                    ExecuteInGameThread(function()
                                        if trial~=nil or not human_still_controls_original(state) or
                                           not wild_ai_controls_tracked_pal(state) then
                                            block('AI_IDLE_RECHECK_FAILED: original controller or human identity changed')
                                            return
                                        end
                                        if native_pal_ai_active(state.ai)~=false then
                                            block('AI_IDLE_RECHECK_FAILED: native AI diverged from inactive baseline')
                                            return
                                        end
                                        local _,empty_now,present_now=native_pal_action_snapshot(state.ai)
                                        if present_now==true and empty_now~=true then
                                            ai_action_quarantine[state.pal_key]=nil
                                            ai_postcheck_pending=false
                                            log('AI_IDLE_ACTION_RETURNED: original controller and human verified; action present; Xbox behavior still needs confirmation')
                                            return
                                        end
                                        -- v1.10.2: witnessed failure on Xbox: returned NPC
                                        -- remained standing still. Previously baseline=false and
                                        -- post=false caused only quarantine; never attempted wake.
                                        -- This is a SINGLE guarded activation of the EXACT
                                        -- original AI, never a broad scan or global flag.
                                        ai_action_quarantine[state.pal_key]=state.ai_key
                                        if state.native_reactivate_attempted then
                                            ai_postcheck_pending=false
                                            log('AI_IDLE_WAKE_SKIPPED: prior attempt already made; exact NPC/Pal remains quarantined')
                                            return
                                        end
                                        local current_component=get_native_ai_component(state.ai)
                                        if not state.ai_component_key or not valid(current_component) or
                                           actor_key(current_component)~=state.ai_component_key then
                                            ai_postcheck_pending=false
                                            log('AI_IDLE_WAKE_SKIPPED: original action component changed/unavailable; actor quarantined')
                                            return
                                        end
                                        state.native_reactivate_attempted=true
                                        local called=pcall(function() state.ai:SetActiveAI(true) end)
                                        local activated=native_pal_ai_active(state.ai)
                                        log('AI_IDLE_NATIVE_WAKE_ATTEMPT: target_kind='..tostring(state.target_kind)..
                                            '; exact_original_ai=true; called='..tostring(called)..
                                            '; IsActiveAI_after='..tostring(activated)..
                                            '; one_attempt_only=true; Xbox_behavior_unverified=true')
                                        if not called then
                                            ai_postcheck_pending=false
                                            log('AI_IDLE_NATIVE_WAKE_UNVERIFIED: SetActiveAI native call unavailable; actor quarantined; other targets allowed')
                                            return
                                        end
                                        if activated~=true then
                                            log('AI_IDLE_NATIVE_WAKE_PENDING: activation not immediate; delayed final read required')
                                        end
                                        -- CacheControlledPawn_BP is restricted to the
                                        -- same saved component and original controller.
                                        local recached=pcall(function() current_component:CacheControlledPawn_BP() end)
                                        log('AI_IDLE_NATIVE_RECACHE: same_component=true; called='..tostring(recached)..'; no_other_actor_modified=true')
                                        local final_scheduled=pcall(function()
                                            ExecuteWithDelay(AI_FINALCHECK_DELAY_MS,function()
                                                local final_dispatched=pcall(function()
                                                    ExecuteInGameThread(function()
                                                        if trial~=nil or not human_still_controls_original(state) or
                                                           not wild_ai_controls_tracked_pal(state) or
                                                           not valid(current_component) or
                                                           actor_key(current_component)~=state.ai_component_key then
                                                            block('AI_IDLE_NATIVE_FINAL_UNCERTAIN: original identities changed')
                                                            return
                                                        end
                                                        local is_active=native_pal_ai_active(state.ai)
                                                        local _,empty_after,action_after=native_pal_action_snapshot(state.ai)
                                                        if is_active==true and action_after==true and empty_after~=true then
                                                            ai_action_quarantine[state.pal_key]=nil
                                                            log('AI_IDLE_NATIVE_WAKE_VERIFIED: controller active and action present; BEHAVIOR_REQUIRES_XBOX_CHECK')
                                                        else
                                                            ai_action_quarantine[state.pal_key]=state.ai_key
                                                            log('AI_IDLE_NATIVE_WAKE_PARTIAL: active='..tostring(is_active)..
                                                                '; action_present='..tostring(action_after)..
                                                                '; action_empty='..tostring(empty_after)..
                                                                '; original actor quarantined; other targets allowed; NO recovery claim')
                                                            -- v1.10.4: just SetActiveAI(true) was INSUFFICIENT on Xbox.
                                                            -- Restore Palworld's DEFAULT AI action, not AI combat,
                                                            -- hatred or an invented attack, and NEVER apply to another actor.
                                                            -- The Wild controller blueprint inherits PlayDefaultAction
                                                            -- from BP_MonsterAIControllerBase. Human NPC blueprints
                                                            -- use StartDefaultAIAction. No rebinding of a new controller.
                                                            if is_active==true and action_after~=true and empty_after==true and
                                                               not state.default_action_attempted then
                                                                if not wild_ai_controls_tracked_pal(state) or
                                                                   not human_still_controls_original(state) or
                                                                   not valid(current_component) or
                                                                   actor_key(current_component)~=state.ai_component_key then
                                                                    block('AI_DEFAULT_ACTION_SKIPPED: exact tracked identities changed; no_native_call')
                                                                    return
                                                                end
                                                                local method=(state.target_kind=='PAL' and 'PlayDefaultAction') or
                                                                    (state.target_kind=='NPC' and 'StartDefaultAIAction') or nil
                                                                if not method then
                                                                    ai_postcheck_pending=false
                                                                    log('AI_DEFAULT_ACTION_SKIPPED: unknown kind; actor stays quarantined')
                                                                    return
                                                                end
                                                                state.default_action_attempted=true
                                                                local called=pcall(function()
                                                                    if state.target_kind=='PAL' then
                                                                        state.ai:PlayDefaultAction()
                                                                    else
                                                                        state.ai:StartDefaultAIAction()
                                                                    end
                                                                end)
                                                                log('AI_DEFAULT_ACTION_ATTEMPT: kind='..state.target_kind..
                                                                    '; method='..method..'; called='..tostring(called)..
                                                                    '; once_only=true; original_controller_only=true; no_damage_or_aggro_writes=true')
                                                                if not called then
                                                                    ai_postcheck_pending=false
                                                                    log('AI_DEFAULT_ACTION_UNAVAILABLE: Blueprint method failed or missing; original actor quarantined; no retry')
                                                                    return
                                                                end
                                                                local scheduled=pcall(function()
                                                                    ExecuteWithDelay(AI_FINALCHECK_DELAY_MS,function()
                                                                        local dispatched=pcall(function()
                                                                            ExecuteInGameThread(function()
                                                                                if trial~=nil or
                                                                                   not human_still_controls_original(state) or
                                                                                   not wild_ai_controls_tracked_pal(state) or
                                                                                   not valid(current_component) or
                                                                                   actor_key(current_component)~=state.ai_component_key then
                                                                                    block('AI_DEFAULT_ACTION_UNCERTAIN: original pawn/controller/human/component changed')
                                                                                    return
                                                                                end
                                                                                local active_final=native_pal_ai_active(state.ai)
                                                                                local _,empty_final,present_final=native_pal_action_snapshot(state.ai)
                                                                                if active_final==true and present_final==true and empty_final~=true then
                                                                                    ai_action_quarantine[state.pal_key]=nil
                                                                                    log('AI_DEFAULT_ACTION_PRESENT: original AI action restored; verify movement AND attacks on Xbox; not yet guaranteed')
                                                                                else
                                                                                    ai_action_quarantine[state.pal_key]=state.ai_key
                                                                                    log('AI_DEFAULT_ACTION_STILL_MISSING: active='..tostring(active_final)..
                                                                                        '; action_present='..tostring(present_final)..
                                                                                        '; action_empty='..tostring(empty_final)..
                                                                                        '; actor quarantined; other actors allowed')
                                                                                end
                                                                                ai_postcheck_pending=false
                                                                            end)
                                                                        end)
                                                                        if not dispatched then block('AI_DEFAULT_ACTION_UNCERTAIN: game-thread callback unavailable') end
                                                                    end)
                                                                end)
                                                                if not scheduled then block('AI_DEFAULT_ACTION_UNCERTAIN: delayed verification unavailable') end
                                                                return
                                                            end
                                                        end
                                                        ai_postcheck_pending=false
                                                    end)
                                                end)
                                                if not final_dispatched then block('AI_IDLE_NATIVE_FINAL_UNAVAILABLE: game-thread dispatch failed') end
                                            end)
                                        end)
                                        if not final_scheduled then block('AI_IDLE_NATIVE_FINAL_UNAVAILABLE: timer failed') end
                                    end)
                                end)
                                if not dispatched then block('AI_IDLE_RECHECK_UNAVAILABLE: game-thread dispatch failed') end
                            end)
                        end)
                        if not scheduled then block('AI_IDLE_RECHECK_UNAVAILABLE: timer failed') end
                        return
                    end
                    if lost_action then
                        if not state.ai_component_key or not component_present then
                            block('AI_ACTION_RECOVERY_UNAVAILABLE: original action component absent')
                            return
                        end
                        local component=get_native_ai_component(state.ai)
                        local ok_repair,reason=repair_missing_ai_actions(state,component)
                        if not ok_repair then
                            block('AI_ACTION_RECOVERY_FAILED: '..reason)
                            return
                        end
                        log('AI_ACTION_REPAIR_ATTEMPT: '..reason..'; one_time=true; action_not_yet_verified=true')
                        local scheduled=pcall(function()
                            ExecuteWithDelay(AI_FINALCHECK_DELAY_MS,function()
                                local dispatched=pcall(function()
                                    ExecuteInGameThread(function()
                                        if trial~=nil or not human_still_controls_original(state) or
                                           not wild_ai_controls_tracked_pal(state) then
                                            block('AI_ACTION_REPAIR_UNCERTAIN: original actor/controller changed')
                                            return
                                        end
                                        local check_component=get_native_ai_component(state.ai)
                                        if not valid(check_component) or actor_key(check_component)~=state.ai_component_key then
                                            block('AI_ACTION_REPAIR_UNCERTAIN: component identity changed')
                                            return
                                        end
                                        local _,empty_now,present_now=native_pal_action_snapshot(state.ai)
                                        if present_now~=true or empty_now==true then
                                            -- v1.10.7: real Xbox NPC repeat test (28/10, 15:11 UTC):
                                            -- the first NPC return recovered via StartDefaultAIAction,
                                            -- but the second had an ACTIVE original controller with
                                            -- an empty native action. The old global block prevented
                                            -- ALL unrelated Pal/NPC possessions indefinitely.
                                            -- If the SAME original AI/controller/component/human are
                                            -- proven, attempt only that NPC/Pal default action once;
                                            -- quarantine this actor if still missing. Never clear a
                                            -- global safety lock when identity or restoration is lost.
                                            local active_after_rebind=native_pal_ai_active(state.ai)
                                            if state.pal_ai_was_active==true and active_after_rebind==true and
                                               (state.target_kind=='NPC' or state.target_kind=='PAL') then
                                                ai_action_quarantine[state.pal_key]=state.ai_key
                                                local method=state.target_kind=='NPC' and 'StartDefaultAIAction' or 'PlayDefaultAction'
                                                if state.default_action_attempted then
                                                    ai_postcheck_pending=false
                                                    log('AI_ACTIVE_DEFAULT_ACTION_SKIPPED: already attempted; this actor quarantined; unrelated actors allowed')
                                                    return
                                                end
                                                state.default_action_attempted=true
                                                local called=pcall(function()
                                                    if state.target_kind=='NPC' then state.ai:StartDefaultAIAction()
                                                    else state.ai:PlayDefaultAction() end
                                                end)
                                                log('AI_ACTIVE_DEFAULT_ACTION_ATTEMPT: kind='..state.target_kind..
                                                    '; method='..method..'; called='..tostring(called)..
                                                    '; original_controller_only=true; once_only=true; other_actors_unmodified=true')
                                                if not called then
                                                    ai_postcheck_pending=false
                                                    log('AI_ACTIVE_DEFAULT_ACTION_UNAVAILABLE: this actor quarantined; unrelated Pal/NPC trials allowed')
                                                    return
                                                end
                                                local scheduled_final=pcall(function()
                                                    ExecuteWithDelay(AI_FINALCHECK_DELAY_MS,function()
                                                        local dispatched_final=pcall(function()
                                                            ExecuteInGameThread(function()
                                                                if trial~=nil or not human_still_controls_original(state) or
                                                                   not wild_ai_controls_tracked_pal(state) or
                                                                   not valid(check_component) or
                                                                   actor_key(check_component)~=state.ai_component_key then
                                                                    block('AI_ACTIVE_DEFAULT_ACTION_UNCERTAIN: exact original identity changed')
                                                                    return
                                                                end
                                                                local final_active=native_pal_ai_active(state.ai)
                                                                local _,final_empty,final_action=native_pal_action_snapshot(state.ai)
                                                                if final_active==true and final_action==true and final_empty~=true then
                                                                    ai_action_quarantine[state.pal_key]=nil
                                                                    log('AI_ACTIVE_DEFAULT_ACTION_PRESENT: native action restored on original actor; Xbox movement/attack still requires visual verification')
                                                                else
                                                                    ai_action_quarantine[state.pal_key]=state.ai_key
                                                                    log('AI_ACTIVE_DEFAULT_ACTION_STILL_MISSING: active='..tostring(final_active)..
                                                                        '; action_present='..tostring(final_action)..
                                                                        '; action_empty='..tostring(final_empty)..
                                                                        '; exact actor quarantined; unrelated actors allowed')
                                                                end
                                                                ai_postcheck_pending=false
                                                            end)
                                                        end)
                                                        if not dispatched_final then block('AI_ACTIVE_DEFAULT_ACTION_UNCERTAIN: game-thread dispatch failed') end
                                                    end)
                                                end)
                                                if not scheduled_final then block('AI_ACTIVE_DEFAULT_ACTION_UNCERTAIN: delayed verification failed') end
                                                return
                                            end
                                            block('AI_ONEPAL_RESET_UNVERIFIED: original AI not verified after root rebind')
                                            return
                                        end
                                        if state.pal_ai_was_active==true and native_pal_ai_active(state.ai)~=true then
                                            block('AI_ACTION_REPAIR_UNVERIFIED: native IsActiveAI still false after baseline true')
                                            return
                                        end
                                        ai_postcheck_pending=false
                                        log('AI_ONEPAL_RESET_ACTION_PRESENT: original Wild action present after local rebind; BEHAVIOR_NOT_VERIFIED; visual check required')
                                    end)
                                end)
                                if not dispatched then block('AI_ACTION_REPAIR_UNAVAILABLE: final dispatch failed') end
                            end)
                        end)
                        if not scheduled then block('AI_ACTION_REPAIR_UNAVAILABLE: final timer failed') end
                        return
                    end
                    if state.pal_ai_was_active==true and active==false then
                        if state.native_reactivate_attempted then
                            block('AI_NATIVE_REACTIVATE_BLOCKED: already attempted')
                            return
                        end
                        state.native_reactivate_attempted=true
                        log('AI_NATIVE_REACTIVATE_ATTEMPT: original Wild AI true->false; calling SetActiveAI(true) once; Palworld-specific')
                        local called=pcall(function() state.ai:SetActiveAI(true) end)
                        if not called or native_pal_ai_active(state.ai)~=true then
                            block('AI_NATIVE_REACTIVATE_FAILED: native call error or IsActiveAI still false')
                            return
                        end
                        local final_scheduled=pcall(function()
                            ExecuteWithDelay(AI_FINALCHECK_DELAY_MS,function()
                                local sent=pcall(function()
                                    ExecuteInGameThread(function()
                                        if trial~=nil or not human_still_controls_original(state) or
                                           not wild_ai_controls_tracked_pal(state) then
                                            block('AI_NATIVE_FINAL_UNCERTAIN: tracked identities changed')
                                            return
                                        end
                                        local after=native_pal_ai_active(state.ai)
                                        local _,after_empty,after_action=native_pal_action_snapshot(state.ai)
                                        if after~=true then
                                            block('AI_NATIVE_REACTIVATE_UNSTABLE: IsActiveAI not true at final check')
                                            return
                                        end
                                        if state.pal_ai_action_empty==false and after_empty==true then
                                            block('AI_NATIVE_ACTION_LOST: AI activated but original action stack remains empty')
                                            return
                                        end
                                        ai_postcheck_pending=false
                                        log('AI_NATIVE_REACTIVATE_STABLE: EXACT original Wild AI IsActiveAI=true; action_empty='..
                                            tostring(after_empty)..'; action_present='..tostring(after_action)..
                                            '; BEHAVIOR_NOT_VERIFIED; inspect Pal in Xbox before another test')
                                    end)
                                end)
                                if not sent then block('AI_NATIVE_FINAL_UNAVAILABLE: game-thread dispatch failed') end
                            end)
                        end)
                        if not final_scheduled then block('AI_NATIVE_FINAL_UNAVAILABLE: delayed verification failed') end
                        return
                    end
                    if state.pal_ai_was_active==true and active==true then
                        if state.pal_ai_action_empty==false and action_empty==true then
                            block('AI_NATIVE_ACTION_LOST: Wild active but baseline nonempty action stack now empty')
                        else
                            ai_postcheck_pending=false
                            log('AI_NATIVE_ACTIVE_OK: original Wild IsActiveAI=true; no mutation; action_empty='..tostring(action_empty)..
                                '; BEHAVIOR_NOT_VERIFIED; inspect Pal in Xbox')
                        end
                        return
                    end
                    if state.pal_ai_was_active==false and active==false then
                        if state.pal_ai_action_present==true and action_present~=true then
                            block('AI_ACTION_RECOVERY_UNVERIFIED: original action missing')
                            return
                        end
                        ai_postcheck_pending=false
                        log('AI_NATIVE_BASELINE_INACTIVE: Wild AI inactive before AND after; preserved original state; no mutation')
                        return
                    end
                    if state.pal_ai_was_active==false and active==true then
                        block('AI_NATIVE_UNEXPECTED_ACTIVATION: baseline false, post true; no mutation')
                        return
                    end
                    -- API native indisponivel na versao em execucao: seguir com
                    -- diagnostico BrainComponent legado, mas NUNCA forcar unverified.
                    local brain=tracked_brain(state.ai)
                    if not valid(brain) or not state.brain_key or actor_key(brain)~=state.brain_key then
                        block('AI_NATIVE_UNAVAILABLE: IsActiveAI baseline/current unavailable; UE BrainComponent also missing')
                        return
                    end
                    local running,paused=brain_read(brain)
                    if state.brain_was_running==true and running==true and paused~=true then
                        ai_postcheck_pending=false
                        log('AI_FALLBACK_BRAIN_OK: same Wild Unreal brain still running; BEHAVIOR_NOT_VERIFIED')
                    else
                        block('AI_NATIVE_UNAVAILABLE: status unknown; no unverified RestartLogic')
                    end
                end)
            end)
            if not dispatch then
                ai_postcheck_pending=false;ai_recovery_uncertain=true
                log('AI_POSTCHECK_UNAVAILABLE: game-thread dispatch failed; new trials blocked')
            end
        end)
    end)
    if ok then
        log('AI_POSTCHECK_ARMED: delayed EXACT original Wild AI action check; optional one-Pal composite rebind')
    else
        ai_postcheck_pending=false;ai_recovery_uncertain=true
        log('AI_POSTCHECK_UNAVAILABLE: timer failed; new trials blocked')
    end
end
-- A integracao Palworld no CLIENTE Xbox pode manter caches de interacao
-- depois que o servidor devolveu o Pawn. Nao destruir/recriar jogador,
-- reiniciar servidor, forcar ClientReset ou alterar PlayerInput. Em vez disso,
-- so uma ClientRestart(humano) FORCADA (nao Retry) e verificada por identidade.
-- Teste experimental: entrega RPC nao prova que a UI de interacao reativou.
local function human_interact_sync(reason,expected_pc_key,expected_human_key,expected_class)
    if trial then return 'INTERACT_SYNC_BLOCKED: active_possession; no_rpc_sent=true' end
    local pc,_,issue=verified_owner_online(true)
    if not pc then return 'INTERACT_SYNC_BLOCKED: original_owner_not_online_admin; no_rpc_sent=true' end
    if expected_pc_key and actor_key(pc)~=expected_pc_key then
        return 'INTERACT_SYNC_BLOCKED: owner_controller_changed; no_rpc_sent=true'
    end
    local ok,human=pcall(function() return pc:K2_GetPawn() end)
    if not ok or not valid(human) or human:HasAuthority()~=true then
        return 'INTERACT_SYNC_BLOCKED: human_pawn_unavailable; no_rpc_sent=true'
    end
    local key=actor_key(human)
    local cls=pawn_class_name(human)
    if not key or not cls or not cls:match('^BP_Player_[%w_]+_C$') or
       (expected_human_key and key~=expected_human_key) or
       (expected_class and cls~=expected_class) then
        return 'INTERACT_SYNC_BLOCKED: human_identity_changed; no_rpc_sent=true'
    end
    local verified,controlled,alive=pcall(function()
        local controller=human.Controller
        local param=human.CharacterParameterComponent
        return valid(controller) and actor_key(controller)==actor_key(pc),
            valid(param) and param:IsDead()==false
    end)
    if not verified or not controlled or not alive then
        return 'INTERACT_SYNC_BLOCKED: human_controller_or_life_unverified; no_rpc_sent=true'
    end
    if not pal_control.api('/Script/Engine.PlayerController:ClientRestart') then
        return 'INTERACT_SYNC_UNAVAILABLE: ClientRestart_RPC_not_reflected; no_rpc_sent=true'
    end
    -- Exactly one RPC with the same authoritative owner and current human.
    local sent=pcall(function() pc:ClientRestart(human) end)
    if not sent then
        return 'INTERACT_SYNC_FAILED: native_ClientRestart_Lua_error; no_auto_retry=true'
    end
    local still_ok,current=pcall(function() return pc:K2_GetPawn() end)
    if not still_ok or actor_key(current)~=key then
        return 'INTERACT_SYNC_UNCERTAIN: owner_pawn_changed_after_RPC; manual_inspection_required=true'
    end
    return 'INTERACT_SYNC_RPC_SENT: source='..tostring(reason)..'; original_human_and_controller_verified=true; forced_ClientRestart_once=true; no_server_restart=true; no_save_write=true; Xbox_object_interaction_UNVERIFIED=true'
end

local function schedule_human_interact_sync(state,reason)
    if not state or not state.pc_key or not state.human_key or not state.human_class then
        log('INTERACT_SYNC_SKIP: verified_return_identity_missing; no_rpc_sent=true')
        return
    end
    interact_sync_generation=interact_sync_generation+1
    local generation=interact_sync_generation
    local pc_key,human_key,cls=state.pc_key,state.human_key,state.human_class
    if type(ExecuteWithDelay)~='function' or type(ExecuteInGameThread)~='function' then
        log('INTERACT_SYNC_UNAVAILABLE: game_thread_or_timer_missing; use_MANUAL_INTERACT')
        return
    end
    local scheduled=pcall(function()
        ExecuteWithDelay(850,function()
            local queued=pcall(function()
                ExecuteInGameThread(function()
                    if generation~=interact_sync_generation then
                        log('INTERACT_SYNC_SKIP: superseded_return; no_rpc_sent=true')
                        return
                    end
                    -- Never send an old RPC after the admin starts another trial.
                    local worked,result=pcall(human_interact_sync,'automatic_after_'..tostring(reason),pc_key,human_key,cls)
                    log(worked and result or 'INTERACT_SYNC_FAILED: unexpected_Lua_error; no_auto_retry=true')
                end)
            end)
            if not queued then log('INTERACT_SYNC_FAILED: cannot_schedule_game_thread') end
        end)
    end)
    if scheduled then
        log('INTERACT_SYNC_ARMED: delay_ms=850; original_human_only=true; one_client_RPC_max=true; no_save_write=true')
    else
        log('INTERACT_SYNC_UNAVAILABLE: timer_registration_failed; use_MANUAL_INTERACT')
    end
end

local function manual_human_interact_sync()
    local now=os.time()
    if type(now)~='number' or now-interact_sync_manual_ts<3 then
        return 'INTERACT_SYNC_BLOCKED: rate_limit_3s; no_rpc_sent=true'
    end
    interact_sync_manual_ts=now
    return human_interact_sync('manual_owner_request',nil,nil,nil)
end

-- RETORNO AO /spectate NATIVO: nao confundir com CVGSPEC do mod.
-- A sessao usa apenas objetos autenticados que ja foram rastreados.
-- A posicao salva e SOMENTE metadado Lua, nunca move o humano real.
function pal_control.spec_save_pal_position(state,source)
    if not state or state.spec_from_native_game~=true or not valid(state.pal) then return false end
    local ok,pos=pcall(function() return state.pal:K2_GetActorLocation() end)
    if not ok or pos==nil then return false end
    local x,y,z=pos.X,pos.Y,pos.Z
    if not (num_in_range(x,1e8) and num_in_range(y,1e8) and num_in_range(z,1e8)) then return false end
    state.spec_pal_last_pos={x=x,y=y,z=z}
    state.spec_pal_last_at=os.time()
    state.spec_pal_last_source=source
    return true
end

function pal_control.spec_resume_native(source)
    local saved=pal_control.spec_pending
    if not saved then return 'SPECRESUME_BLOCKED: no_previous_native_game_spectate' end
    if trial or recovery_lock then return 'SPECRESUME_BLOCKED: possession_or_recovery_active; no_native_call' end
    local pc,_,problem=verified_owner_online(false)
    if not pc or actor_key(pc)~=saved.pc_key then
        return 'SPECRESUME_BLOCKED: original_admin_controller_not_verified; no_native_call'
    end
    local ok,pawn=pcall(function()return pc:K2_GetPawn()end)
    if not ok or not valid(pawn) or actor_key(pawn)~=saved.human_key or
       pawn_class_name(pawn)~=saved.human_class then
        return 'SPECRESUME_BLOCKED: original_human_not_current_pawn; no_native_call'
    end
    if not valid(saved.human) or actor_key(saved.human)~=saved.human_key or
       pc.bAdmin~=true then
        return 'SPECRESUME_BLOCKED: original_human_or_admin_invalid; no_native_call'
    end
    local already_ok,already=pcall(function()return pc:IsSpectating()end)
    if already_ok and already==true then
        saved.started=true
        return 'SPECRESUME_ALREADY_SPECTATING: no_duplicate_BeginSpectate; use_GAME_ToggleSpectate_to_return_human'
    end
    -- A prioridade e ter o humano seguro; chamada nativa so AQUI, DEPOIS do journal SAFE.
    local begun=pcall(function()pc:BeginSpectate(true)end)
    if not begun then
        return 'SPECRESUME_NATIVE_ERROR: BeginSpectate_failed; human_kept; use_GAME_ToggleSpectate_manually'
    end
    local state_ok,in_mode=pcall(function()return pc:IsSpectating()end)
    local sp_ok,sp=pcall(function()return pc:GetSpectatorPawn()end)
    local sp_valid=sp_ok and valid(sp)
    if not (state_ok and in_mode==true) and not sp_valid then
        return 'SPECRESUME_UNCONFIRMED: BeginSpectate_called; Xbox_state_unknown; no_camera_teleport'
    end
    saved.started=true
    -- Somente reposicionar o SpectatorPawn autoritativo que o modo nativo criou.
    -- Se a camera existir apenas no Xbox, NAO tentar um TeleportTo do humano.
    if not sp_valid then
        return 'SPECRESUME_MODE_REQUESTED: spectator_pawn_not_on_server; position_at_pal_UNVERIFIED; use_GAME_ToggleSpectate_to_return_human'
    end
    local same=actor_key(sp)
    local kind=pawn_class_name(sp)
    local low=type(kind)=='string' and kind:lower() or ''
    if not same or same==saved.human_key or
       not (low:find('spectator',1,true) or low:find('camera',1,true)) then
        return 'SPECRESUME_MODE_REQUESTED: spectator_identity_unverified; position_not_changed'
    end
    local auth_ok,auth=pcall(function()return sp:HasAuthority()end)
    if not auth_ok or auth~=true then
        return 'SPECRESUME_MODE_REQUESTED: spectator_pawn_client_only; position_not_changed'
    end
    if not saved.pos or not pal_control.api('/Script/Engine.Actor:K2_TeleportTo') then
        return 'SPECRESUME_MODE_REQUESTED: no_safe_location_or_native_teleport_reflection; position_not_changed'
    end
    -- Exatamente UMA tentativa por comando/retorno; sem loop ou repeticao automatica.
    -- 120cm acima do ultimo Pal, para evitar posicionamento dentro do terreno.
    local rot_ok,rot=pcall(function()return sp:K2_GetActorRotation()end)
    local rotation=rot_ok and rot or {Pitch=0,Yaw=0,Roll=0}
    local did_ok,did=pcall(function()
        return sp:K2_TeleportTo({X=saved.pos.x,Y=saved.pos.y,Z=saved.pos.z+120},rotation)
    end)
    if not did_ok or did==false then
        return 'SPECRESUME_MODE_REQUESTED: spectator_teleport_failed; human_untouched; Xbox_position_UNVERIFIED'
    end
    local pos_ok,pos=pcall(function()return sp:K2_GetActorLocation()end)
    local near=false
    if pos_ok and pos then
        local dx,dy,dz=pos.X-saved.pos.x,pos.Y-saved.pos.y,pos.Z-(saved.pos.z+120)
        near=(dx*dx+dy*dy+dz*dz)<(900*900)
    end
    return 'SPECRESUME_POSITION_'..(near and 'SERVER_NEAR_PAL' or 'SERVER_UNVERIFIED')..
       ': source='..tostring(source)..'; original_human_untouched=true; Xbox_camera_UNVERIFIED=true; use_GAME_ToggleSpectate_to_exit'
end

function pal_control.spec_schedule_after_return(state,reason)
    if not state or state.spec_from_native_game~=true then return end
    local saved={pc_key=state.pc_key,human_key=state.human_key,
        human_class=state.human_class,human=state.human,
        pos=state.spec_pal_last_pos or state.spec_entry_pos,
        reason=reason,started=false}
    pal_control.spec_pending=saved
    -- O fluxo original envia ClientRestart ao humano em 850ms; reiniciar
    -- espectador SOMENTE apos esse RPC, sem competicao com o retorno.
    if type(ExecuteWithDelay)~='function' or type(ExecuteInGameThread)~='function' then
        log('SPECRESUME_PENDING: no_scheduler; human_safe; use_SPECRESUME_TXT_to_attempt')
        return
    end
    local queued=pcall(function()
        ExecuteWithDelay(1700,function()
            local ok=pcall(function()
                ExecuteInGameThread(function()
                    if pal_control.spec_pending~=saved then return end
                    local worked,result=pcall(pal_control.spec_resume_native,'automatic_after_'..tostring(reason))
                    log(worked and result or 'SPECRESUME_LUA_ERROR: no_auto_retry; inspect_Xbox')
                end)
            end)
            if not ok then log('SPECRESUME_PENDING: game_thread_unavailable; use_SPECRESUME_TXT') end
        end)
    end)
    if queued then
        log('SPECRESUME_ARMED: native_game_spectator_before_possess=true; human_first=true; delay_ms=1700; last_pal_location_saved='..tostring(saved.pos~=nil)..'; original_human_unchanged=true')
    else
        log('SPECRESUME_PENDING: delay_registration_failed; use_SPECRESUME_TXT')
    end
end

function pal_control.spec_end_native()
    local saved=pal_control.spec_pending
    if not saved then return 'SPECEND_BLOCKED: no_verified_native_spectator_return' end
    if trial or recovery_lock then return 'SPECEND_BLOCKED: trial_or_recovery_active' end
    local pc=verified_owner_online(false)
    if not pc or actor_key(pc)~=saved.pc_key or pc.bAdmin~=true or
       not valid(saved.human) or actor_key(saved.human)~=saved.human_key then
        return 'SPECEND_BLOCKED: tracked_human_or_controller_changed; no_native_call'
    end
    local is_ok,is_spec=pcall(function()return pc:IsSpectating()end)
    if is_ok and is_spec==false then
        local ok,pawn=pcall(function()return pc:K2_GetPawn()end)
        if ok and valid(pawn) and actor_key(pawn)==saved.human_key then
            pal_control.spec_pending=nil
            return 'SPECEND_ALREADY_HUMAN: original_human_verified; no_native_call'
        end
        return 'SPECEND_UNCONFIRMED: not_spectating_but_human_not_verified'
    end
    local ended=pcall(function()pc:EndSpectate()end)
    if not ended then return 'SPECEND_NATIVE_FAILED: original_human_not_modified; inspect_Xbox' end
    local ok,pawn=pcall(function()return pc:K2_GetPawn()end)
    if ok and valid(pawn) and actor_key(pawn)==saved.human_key and
       pawn_class_name(pawn)==saved.human_class then
        pal_control.spec_pending=nil
        return 'SPECEND_HUMAN_OK: exact_original_human_verified; Xbox_client_confirmation_needed'
    end
    return 'SPECEND_UNCERTAIN: EndSpectate_called_but_original_human_not_verified; no_extra_Possess'
end

local function restore_trial(reason)
    if not trial then return 'RETURN_IDLE: no active trial' end
    if trial.restoring then return 'RETURN_BUSY: restoration already running' end
    local state=trial
    -- Validate a CURRENT owner controller. The saved controller can belong to
    -- a disconnected client and must NEVER be reused blindly on reconnect.
    local pc,players,why=verified_owner_online(false)
    if not pc then
        state.offline=true
        return 'RECOVERY_WAIT_OFFLINE: no current owner controller; no native call'
    end
    local ok,pawn=pcall(function() return pc:K2_GetPawn() end)
    if not ok then
        return 'RETURN_FAILED: controller pawn read error; no native call; inspection required'
    end
    local pawn_valid=valid(pawn)
    local new_pc_key=actor_key(pc)
    if state.pc_key and new_pc_key and state.pc_key~=new_pc_key then
        state.offline=true
        log('RECOVERY_NEW_CONTROLLER: native identity changed; old controller not reused')
        return 'RETURN_BLOCKED: owner_controller_changed; original_session_preserved; no_native_call'
    end
    -- Se o Pal morreu/foi capturado, o PC pode estar temporariamente SEM Pawn.
    -- NUNCA fazer resgate nesse caso usando um controller novo de reconexao.
    -- Exige evidencias de perda do alvo original e identidade nativa do PC igual.
    local lost_pawn_rescue=(not pawn_valid and state.pal_lost==true)
    if not pawn_valid and not lost_pawn_rescue then
        return 'RETURN_FAILED: current owner pawn not ready; no native call; retry manually later'
    end
    if lost_pawn_rescue and (not state.pc_key or not new_pc_key or state.pc_key~=new_pc_key or state.offline) then
        return 'PAL_DANGER_RETURN_BLOCKED: pawn missing, owner controller changed or offline; no native call; inspect human on reconnect'
    end
    if pawn_matches_human(pawn,state.human_class) then
        if state.focus_dirty then
            if actor_key(pawn)~=state.human_key then
                state.offline=true
                return 'RETURN_BLOCKED: different_human_spawn; no_native_call; original_session_retained'
            end
            if not pal_control.restore(state,pc,pawn) then
                return 'RETURN_UNCERTAIN: camera_or_visibility_restore_pending; retry_RETURN_after_review'
            end
            if not state.pal_lost and not state.ai_returned then
                if not pal_control.return_ai(state) then
                    return 'RETURN_UNCERTAIN: original_Wild_AI_restore_pending; no_new_trial'
                end
            end
        end
        -- The game itself may have restored/spawned the avatar. Never call
        -- Possess in this case (prevents hijacking a valid reconnect spawn).
        -- IMPORTANTE: registrar antigo corpo original ANTES de limpar trial.
        track_old_human_if_distinct(state,pawn)
        if not capture_guard.restore(state) then
            return 'RETURN_UNCERTAIN: exact_Pal_capture_flags_not_restored; original human controlled; retry RETURN; journal_ACTIVE'
        end
        range_restore_actor(state)
        if recovery_journal_write(false) then
            if not state.pal_lost then pal_control.spec_save_pal_position(state,'already_human_return') end
            trial=nil;recovery_lock=false;recovery_class=nil
            schedule_human_interact_sync(state,'already_human')
            pal_control.spec_schedule_after_return(state,'already_human')
            if state.temporary_boss==true then
                log('BOSSRETURN_HUMAN_OK: human already controlled; journal SAFE; actor cleanup follows')
                if type(boss_cleanup_after_return)=='function' then log(boss_cleanup_after_return('human_already_controlled')) end
                return 'BOSSRETURN_OK: verified human and SAFE journal; temporary actor cleanup attempted'
            end
            if type(pal_control.dead_pal_cleanup_after_return)=='function' then pal_control.dead_pal_cleanup_after_return(state,'already_human') end
            return 'RETURN_CALLED: human pawn already controlled by current owner; journal cleared; verify Xbox'
        end
        return 'RETURN_UNCERTAIN: human visible but SAFE journal write failed; new trial locked'
    end
    if (state.restore_attempts or 0)>=RECOVERY_MAX_NATIVE_RESTORES then
        return 'RETURN_FAILED: native restore budget exhausted; operator inspection required'
    end
    if not valid(state.human) or not state.human:HasAuthority() or
       not pawn_matches_human(state.human,state.human_class) then
        return 'RETURN_FAILED: original human pawn invalid or class changed; no native call'
    end
    -- NUNCA assumir que outro Pal de mesma especie e o alvo original.
    -- Se houve morte/captura, resgate sem pawn so e admitido com mesmo PC
    -- e original humano valido, e no maximo uma tentativa automatica.
    if pawn_valid and (not state.pal_key or actor_key(pawn)~=state.pal_key) then
        return 'RETURN_FAILED: current pawn is not the tracked original Pal; no native call'
    end
    if state.offline and pc.bAdmin~=true then
        return 'RETURN_FAILED: owner admin must be active for reconnect rescue; no native call'
    end
    local life_ok,human_alive=pcall(function()
        local p=state.human.CharacterParameterComponent
        return valid(p) and p:IsDead()==false
    end)
    if not life_ok or not human_alive then
        return 'RETURN_BLOCKED: preserved_human_dead_or_unreadable; no_native_call'
    end
    local human_controller_read,human_controller=pcall(function()return state.human.Controller end)
    if not human_controller_read or (valid(human_controller) and actor_key(human_controller)~=new_pc_key) then
        return 'RETURN_BLOCKED: original_human_controlled_elsewhere; no_native_call'
    end
    -- Salvar ultima coordenada do Pal quando ainda legivel, inclusive na morte.
    if not state.pal_lost then pal_control.spec_save_pal_position(state,'return_before_human_possess') end
    state.restoring=true
    state.restore_attempts=(state.restore_attempts or 0)+1
    log('RETURN_STAGE_1: verified current owner; attempting native restore; reason='..reason..'; pal_lost='..tostring(state.pal_lost==true))
    local okay=pcall(function() pc:Possess(state.human) end)
    state.restoring=false
    if not okay then
        return 'RETURN_FAILED: native Possess(human) reported Lua error; review before further attempts'
    end
    local verified,current=pcall(function()return pc:K2_GetPawn()end)
    if not verified or not pawn_matches_human(current,state.human_class) or actor_key(current)~=state.human_key then
        return 'RETURN_UNCERTAIN: native call made but current pawn not verified as human'
    end
    if state.focus_dirty and not pal_control.restore(state,pc,current) then
        return 'RETURN_UNCERTAIN: human_recovered_but_camera_or_visibility_restore_pending; journal_ACTIVE'
    end
    -- Boss avatar is disposable. Never apply the wild AI recovery to it.
    -- Only after verifying human and a persistent SAFE journal can we delete it.
    if state.temporary_boss==true then
        if not recovery_journal_write(false) then
            return 'BOSSRETURN_UNCERTAIN: human verified but persistent SAFE journal failed; actor NOT deleted; inspect'
        end
        trial=nil;recovery_lock=false;recovery_class=nil
        schedule_human_interact_sync(state,'temporary_boss_return')
        log('BOSSRETURN_HUMAN_OK: original player pawn restored; journal SAFE; wild AI NOT restored')
        if type(boss_cleanup_after_return)=='function' then log(boss_cleanup_after_return('verified_human_return')) end
        return 'BOSSRETURN_OK: verified original human; tracked temporary Pal cleanup attempted; Xbox confirmation required'
    end
    -- Avoid touching the old wild AI during a disconnect/reconnect: actor
    -- references may be stale or game may already have despawned the Pal.
    local ai_restoration_started=false
    if not state.offline and not state.pal_lost and state.pc_key and new_pc_key==state.pc_key and valid(state.ai) and valid(state.pal) and
        state.ai_key and actor_key(state.ai)==state.ai_key and state.pal_key and actor_key(state.pal)==state.pal_key then
        log('RETURN_STAGE_2: restoring EXACT original Wild AI controller')
        local ai_pawn_read,ai_pawn=pcall(function()return state.ai:K2_GetPawn()end)
        if not ai_pawn_read or (valid(ai_pawn) and actor_key(ai_pawn)~=state.pal_key) then
            ai_recovery_uncertain=true
            return 'RETURN_UNCERTAIN: human_recovered; original_AI_now_controls_other_actor; no_AI_native_call; journal_ACTIVE'
        end
        state.ai_restore_attempted=true
        local reattached=pcall(function() state.ai:Possess(state.pal) end)
        if not reattached or not wild_ai_controls_tracked_pal(state) then
            ai_recovery_uncertain=true
            log('RETURN_AI_UNVERIFIED: native Possess failed or Pal.Controller does not match original Wild AI; no retries; new trials blocked')
        else
            state.ai_returned=true
            ai_restoration_started=true
            log('RETURN_AI_CONTROLLER_OK: original Wild controller verified on original Pal; behavior NOT YET verified')
        end
    else
        if state.focus_baseline and not state.pal_lost then ai_recovery_uncertain=true end
        log('RETURN_AI_SKIPPED: original Wild controller/pal unavailable or reconnect path; never touch stale AI')
    end
    if not capture_guard.restore(state) then
        return 'RETURN_UNCERTAIN: human recovered but capture protection restoration unverified; retry RETURN; journal_ACTIVE'
    end
    range_restore_actor(state)
    if not recovery_journal_write(false) then
        trial=nil
        return 'RETURN_UNCERTAIN: human recovered; persistent marker could not be cleared; !cvg confirm required'
    end
    trial=nil;recovery_lock=false;recovery_class=nil
    schedule_human_interact_sync(state,'wild_pal_or_npc_return')
    pal_control.spec_schedule_after_return(state,'wild_pal_or_npc_return')
    if ai_restoration_started then schedule_ai_postcheck(state) end
    if type(pal_control.dead_pal_cleanup_after_return)=='function' then pal_control.dead_pal_cleanup_after_return(state,'verified_return') end
    return 'RETURN_CALLED: verified human-class pawn possessed; Wild AI postcheck='..(ai_restoration_started and 'PENDING' or 'UNCERTAIN')..'; confirm Xbox'
end
-- v1.11.11.20: One-shot cleanup of the EXACT wild Pal previously possessed,
-- and ONLY after death event, human pawn verified, and journal written SAFE.
-- Never delete on CAPTURE. Never remove a live Pal. No world scanning / no loops.
-- Event/arena bosses stay untouched to preserve HARD+ payout and event lifecycle.
function pal_control.dead_pal_cleanup_once(state,source)
    if not state or state.death_cleanup_attempted==true then
        return 'DEATH_DESPAWN_SKIP: already_attempted_or_no_session'
    end
    state.death_cleanup_attempted=true -- before any native access; never retry same actor
    if not pal_control.dead_pal_despawn_enabled or state.death_cleanup_requested~=true or
       state.death_loss_reason~='DEATH' or state.temporary_boss==true or
       state.target_kind~='PAL' or state.pal_lost~=true then
        return 'DEATH_DESPAWN_SKIP: not_dead_wild_possession; no_actor_modified=true'
    end
    if trial or recovery_lock then
        return 'DEATH_DESPAWN_BLOCKED: new_possession_or_recovery_active; no_actor_modified=true'
    end
    local owner=verified_owner_online(true)
    if not valid(owner) or not state.pc_key or actor_key(owner)~=state.pc_key then
        return 'DEATH_DESPAWN_BLOCKED: owner_identity_unverified; no_actor_modified=true'
    end
    local pawn_ok,pawn=pcall(function()return owner:K2_GetPawn()end)
    if not pawn_ok or not valid(pawn) or actor_key(pawn)~=state.human_key or
       not pawn_matches_human(pawn,state.human_class) then
        return 'DEATH_DESPAWN_BLOCKED: exact_human_not_current_pawn; no_actor_modified=true'
    end
    local actor=state.pal
    if not valid(actor) then
        return 'DEATH_DESPAWN_ABSENT: dead_actor_already_removed_by_game=true'
    end
    if not state.pal_key or actor_key(actor)~=state.pal_key or
       pawn_class_name(actor)~=state.pal_class then
        return 'DEATH_DESPAWN_BLOCKED: dead_actor_identity_or_class_mismatch; no_actor_modified=true'
    end
    local class=state.pal_class:lower()
    if class:find('gym',1,true) or class:find('raid',1,true) or
       class:find('tower',1,true) then
        return 'DEATH_DESPAWN_PROTECTED: event_or_arena_boss; reward_lifecycle_untouched=true'
    end
    -- Class is not sufficient to identify event Pals; also check PalID if readable.
    local id_ok,pal_id=pcall(function()
        local param=actor.CharacterParameterComponent
        if not valid(param) then return nil end
        local ind=param:GetIndividualParameter()
        if not valid(ind) then return nil end
        local id=ind:GetCharacterID()
        if type(id)=='string' then return id end
        if id==nil then return nil end
        return id:ToString()
    end)
    if not id_ok or type(pal_id)~='string' then
        return 'DEATH_DESPAWN_BLOCKED: cannot_exclude_event_PalID; no_actor_modified=true'
    end
    local low_id=pal_id:lower()
    if low_id:find('gym',1,true) or low_id:find('raid',1,true) or
       low_id:find('tower',1,true) then
        return 'DEATH_DESPAWN_PROTECTED: event_PalID; reward_lifecycle_untouched=true'
    end
    local inspected,dead,auth,player_controlled,controller=pcall(function()
        local component=actor.CharacterParameterComponent
        if not valid(component) then return nil,nil,nil,nil end
        return component:IsDead(),actor:HasAuthority(),actor:IsPlayerControlled(),actor.Controller
    end)
    if not inspected or dead~=true or auth~=true or player_controlled~=false then
        return 'DEATH_DESPAWN_BLOCKED: death_authority_or_control_unverified; no_actor_modified=true'
    end
    -- A dead body must not have been re-possessed by a different controller.
    if valid(controller) and (not state.ai_key or actor_key(controller)~=state.ai_key) then
        return 'DEATH_DESPAWN_BLOCKED: actor_controlled_by_unexpected_controller; no_actor_modified=true'
    end
    local reflected,fn=pcall(function()
        return StaticFindObject('/Script/Engine.Actor:K2_DestroyActor')
    end)
    if not reflected or not valid(fn) then
        return 'DEATH_DESPAWN_BLOCKED: native_destroy_not_reflected; no_actor_modified=true'
    end
    -- Explicitly destructive native call, only once in an isolated test clone.
    local called=pcall(function()actor:K2_DestroyActor()end)
    if not called then
        return 'DEATH_DESPAWN_UNCERTAIN: native_destroy_Lua_error; never_retry=true'
    end
    local post=pcall(function()
        ExecuteWithDelay(pal_control.dead_pal_despawn_postcheck_ms,function()
            local dispatched=pcall(function()ExecuteInGameThread(function()
                -- Read only: a success from K2_DestroyActor does not mean Xbox mesh gone.
                local still_valid=valid(actor) and actor_key(actor)==state.pal_key
                log(still_valid and
                    'DEATH_DESPAWN_UNCERTAIN: exact_dead_actor_still_valid; no_retry=true' or
                    'DEATH_DESPAWN_ACTOR_ABSENT: exact_dead_actor_no_longer_valid; Xbox_visual_unverified=true')
            end)end)
            if not dispatched then log('DEATH_DESPAWN_POSTCHECK_UNAVAILABLE: no_retry=true') end
        end)
    end)
    if not post then log('DEATH_DESPAWN_POSTCHECK_UNAVAILABLE: timer_unavailable') end
    return 'DEATH_DESPAWN_CALLED: exact_dead_wild_actor=true; source='..tostring(source)..
        '; original_human_verified=true; native_destroy_requested_once=true; Xbox_visual_unverified=true'
end

pal_control.dead_pal_cleanup_after_return=function(state,source)
    if not state or state.death_cleanup_requested~=true or state.death_cleanup_scheduled then
        return false
    end
    state.death_cleanup_scheduled=true
    if type(ExecuteWithDelay)~='function' or type(ExecuteInGameThread)~='function' then
        log('DEATH_DESPAWN_BLOCKED: deferred_game_thread_unavailable; no_actor_modified=true')
        return false
    end
    local queued=pcall(function()
        ExecuteWithDelay(pal_control.dead_pal_despawn_grace_ms,function()
            local dispatched=pcall(function()ExecuteInGameThread(function()
                local worked,result=pcall(pal_control.dead_pal_cleanup_once,state,source)
                log(worked and result or 'DEATH_DESPAWN_LUA_ERROR: never_retry=true')
            end)end)
            if not dispatched then log('DEATH_DESPAWN_BLOCKED: dispatch_failed; no_actor_modified=true') end
        end)
    end)
    if not queued then
        log('DEATH_DESPAWN_BLOCKED: scheduling_failed; no_actor_modified=true')
        return false
    end
    log('DEATH_DESPAWN_SCHEDULED: exact_dead_wild_pal=true; after_human_SAFE=true; grace_ms='..
        tostring(pal_control.dead_pal_despawn_grace_ms)..'; event_boss_protected=true')
    return true
end

-- v1.8.6: protecao por eventos, SEM watchdog ou varreduras periodicas.
-- A API de morte e usada no proprio AdminCommands do servidor CVG.
-- A captura e um evento Blueprint opcional; pode ser tarde demais ou
-- nem expor a referencia do ator capturado. NAO garante retorno.
local function signal_tracked_pal_loss(reason, observed_pal)
    local state=trial
    if not state or state.restoring or state.emergency_pending or state.emergency_attempted or
       not state.pal_key or not valid(observed_pal) then return end
    local seen_key=actor_key(observed_pal)
    if not seen_key or seen_key~=state.pal_key then return end
    -- Nao ler posicao de um ator em destruicao; usar ultimo snapshot valido.
    state.pal_lost=true
    state.death_loss_reason=reason
    state.death_cleanup_requested=(reason=='DEATH' and state.target_kind=='PAL' and
        state.temporary_boss~=true and actor_key(state.pal)==state.pal_key)
    state.emergency_pending=true
    state.emergency_attempted=true -- nao chamar Possess varias vezes em callbacks duplicados
    state.jump_exit_pending=true -- nao competir com o triplo salto
    log('PAL_DANGER_DETECTED: reason='..reason..'; tracked_pal_confirmed=true; no native call inside death/capture callback')
    local scheduled=pcall(function()
        if type(ExecuteInGameThread)~='function' then error('no_game_thread') end
        ExecuteInGameThread(function()
            if trial~=state then return end
            log('PAL_DANGER_RETURN_REQUESTED: reason='..reason..'; attempt=1; game_thread=true')
            local ok,result=pcall(function()return restore_trial('pal_'..reason)end)
            if ok then
                log(result)
            else
                log('PAL_DANGER_RETURN_BLOCKED: Lua error during emergency restore; no retry; inspect server state')
            end
            -- Se ainda esta no Pal, manter diario ACTIVE e impedir nova tentativa.
            -- O RETURN autenticado pelo TXT continua possivel sob verificacoes.
        end)
    end)
    if not scheduled then
        log('PAL_DANGER_RETURN_BLOCKED: game-thread scheduling failed; no native call; TXT RETURN if possible')
    end
end

local function on_pal_dead(_,event)
    if not trial or not event then return end
    -- Conforme AdminCommands: deadInfo:get().SelfActor e o atingido.
    local ok,victim=pcall(function()
        local info=event:get()
        if not info then return nil end
        return info.SelfActor
    end)
    if ok then signal_tracked_pal_loss('DEATH',victim) end
end

local function on_capture_success(ctx)
    if not trial or not ctx then return end
    -- Segundo AdminCommands: esfera.targetHandle:TryGetIndividualActor().
    -- Em alguns casos o ator ja desapareceu no sucesso da captura: FAIL CLOSED.
    local ok,pal=pcall(function()
        local sphere=ctx:get()
        if not valid(sphere) then return nil end
        local h=sphere.targetHandle
        if not valid(h) then return nil end
        return h:TryGetIndividualActor()
    end)
    if ok then signal_tracked_pal_loss('CAPTURE',pal) end
end

-- v1.10.8 /spectate: CAMARM/CAM/CAMCHECK continuam SOMENTE LEITURA.
-- CAMPAL/CAMNPC (manual) chamam o MESMO start_trial, mas so apos provar que
-- a camera de espectador se move no SERVIDOR. Se Xbox-only, bloqueia.
-- Nao usa pc:GetControlRotation como prova de mira; somente distancia 8m.
local function cam_geo(a)
    if not valid(a) then return nil end
    local ok,v=pcall(function() return a:K2_GetActorLocation() end)
    if not ok or not v then return nil end
    local x,y,z=v.X,v.Y,v.Z
    if not (num_in_range(x,1e8) and num_in_range(y,1e8) and num_in_range(z,1e8)) then return nil end
    return {x=x,y=y,z=z}
end
local function cam_delta(a,b)
    if not a or not b then return nil end
    local dx,dy,dz=a.x-b.x,a.y-b.y,a.z-b.z
    return math.sqrt(dx*dx+dy*dy+dz*dz)
end
local function cam_detect(pc)
    local pawn=nil
    local okp,p=pcall(function()return pc:K2_GetPawn()end)
    if okp and valid(p) then pawn=p end
    local spect=nil
    local oks,s=pcall(function()return pc:GetSpectatorPawn()end)
    if oks and valid(s) then spect=s end
    local vt=nil
    local okv,v=pcall(function()return pc:GetViewTarget()end)
    if okv and valid(v) then vt=v end
    local source=nil
    local kind=nil
    if valid(spect) and spect:HasAuthority()==true then
        source=spect;kind='spectator_pawn'
    else
        -- View target so e aceito se classe claramente do espectador e
        -- diferente do humano original. Nunca tratar humano como camera.
        if valid(vt) and vt:HasAuthority()==true then
            local cn=pawn_class_name(vt)
            local low=cn and cn:lower() or ''
            if low:find('spectator',1,true) or low:find('debugcamera',1,true) then
                source=vt;kind='spectator_view_target'
            end
        end
    end
    if not source and valid(pawn) and pawn:HasAuthority()==true then
        local cn=pawn_class_name(pawn)
        local low=cn and cn:lower() or ''
        if low:find('spectator',1,true) or low:find('debugcamera',1,true) then
            source=pawn;kind='spectator_controlled_pawn'
        end
    end
    return source,kind,pawn,spect,vt
end
local camera_action
-- Palworld nativo: UPalSpectateComponent::ServerSyncSpectatorLocation
-- (Unreliable, Server). Quando o proprio Xbox o envia, o movimento da
-- camera atravessa o canal de rede nativo do jogo. Contexto DEVE ser o
-- componente do unico admin rastreado; nunca aceitar coordenadas de chat.
local function on_cvg_spectator_sync(ctx,location_arg,rotation_arg)
    local base=cam_baseline
    if not base or not base.pc_key or not base.spectator_component_key or
       trial or recovery_lock then return end
    local ok,comp,pos,rx,ry=pcall(function()
        local component=ctx and ctx:get()
        if not valid(component) or actor_key(component)~=base.spectator_component_key then return nil,nil end
        local param=location_arg and location_arg:get()
        if not param then return component,nil end
        local x,y,z=tonumber(param.X),tonumber(param.Y),tonumber(param.Z)
        if not (num_in_range(x,1e8) and num_in_range(y,1e8) and num_in_range(z,1e8)) then return component,nil end
        -- A assinatura refletida pode nao ter FRotator ou pode estar inacessivel.
        -- NUNCA usar GetControlRotation como substituto de mira validada do Xbox.
        local yaw,pitch=nil,nil
        local rd,rv=pcall(function()return rotation_arg and rotation_arg:get()end)
        if rd and rv then
            local rr,yy,pp=pcall(function()
                return normalize_angle_precise(tonumber(rv.Yaw)),normalize_angle_precise(tonumber(rv.Pitch))
            end)
            if rr and yy~=nil and pp~=nil then yaw,pitch=yy,pp end
        end
        return component,{x=x,y=y,z=z},yaw,pitch
    end)
    if not ok or not comp or not pos then return end
    -- Comparar a referencia de controller ja guardada, sem varreduras de jogadores por RPC.
    local auth,owner=pcall(function()
        return valid(base.pc) and base.pc:HasAuthority()==true and
            base.pc.bAdmin==true and actor_key(base.pc)==base.pc_key and
            guid(base.pc:GetPlayerUId())==base.owner_guid
    end)
    if not auth or not owner then return end
    local now=os.time()
    if type(now)~='number' then return end
    local before=cam_sync
    local moved=before and cam_delta(pos,before.pos) or nil
    local proven=(before and before.motion_seen==true) or (moved and moved>=SPECTATOR_SYNC_MIN_MOVE_CM) or false
    local counter=(before and before.samples or 0)+1
    cam_sync={pos=pos,at=now,pc_key=base.pc_key,component_key=base.spectator_component_key,
        yaw=rx,pitch=ry,aim_verified=(rx~=nil and ry~=nil),
        motion_seen=proven and true or false,samples=counter}
    if rx~=nil and ry~=nil and (not before or not before.aim_verified) then
        log('CVGSPEC_ROTATION_RPC_OK: Xbox spectator yaw/pitch available from authenticated native RPC; target selection uses approximate cone, NOT pixel/reticle raytrace')
    end
    if not before then
        log('CVGSPEC_RPC_FIRST: ServerSyncSpectatorLocation owner_component_matched=true; waiting_for_1m_server_motion=true; no_player_modified=true')
    elseif proven and not before.motion_seen then
        log('CVGSPEC_RPC_MOVEMENT_OK: server_received_Xbox_camera_motion=true; motion_at_least_1m=true; coordinates_private=true; native_spectator_mode_not_yet_ended=true')
    end
end

local auto_retrial_prepare -- definida mais abaixo, chamada somente apos inicializacao completa
local function cvg_spectate_action(action)
    if pal_control.handoff_pending then return 'CVGSPEC_BLOCKED: camera_handoff_pending; wait_for_verified_human_or_cancel_RETURN' end
    local pc,_,reason=owner_and_count()
    if not pc then return 'CVGSPEC_BLOCKED: admin owner unavailable: '..tostring(reason) end
    if action=='CVGSPEC' and (trial or recovery_lock or ghost or ai_postcheck_pending or ai_recovery_uncertain) then
        local ready,why=auto_retrial_prepare('cvgspec')
        if not ready then return 'CVGSPEC_RETRY_NEEDS_HUMAN: '..tostring(why) end
    end
    if action=='CVGSPEC' then
        -- Captura o humano no proprio comando (sem intervalo CAMARM/manual).
        local armed=camera_action('CAMARM')
        if not armed:find('^CAMARM_OK') then return 'CVGSPEC_BLOCKED: '..armed end
        local base=cam_baseline
        local ok,comp=pcall(function()return pc:GetPalSpectateComponent()end)
        if not ok or not valid(comp) then
            ok,comp=pcall(function()return pc.SpectateComponent end)
        end
        local ck=ok and actor_key(comp) or nil
        if not ck then
            cam_baseline=nil;cam_previous=nil;cam_sync=nil
            return 'CVGSPEC_BLOCKED: PalSpectateComponent not readable; did_not_start_spectate'
        end
        if not spectator_hook_installed then
            cam_baseline=nil;cam_previous=nil;cam_sync=nil
            return 'CVGSPEC_BLOCKED: native ServerSyncSpectatorLocation hook unavailable; did_not_start_spectate'
        end
        base.spectator_component_key=ck;base.pc=pc;base.owner_guid=owner_guid();base.cvg_spectate=true
        cam_sync=nil
        -- O administrador pode ja estar no /spectate nativo apos seguir outro player.
        -- Nao chamar BeginSpectate pela segunda vez no mesmo controlador.
        local state_ok,already=pcall(function() return pc:IsSpectating() end)
        if not state_ok then
            cam_baseline=nil;cam_previous=nil;cam_sync=nil
            return 'CVGSPEC_BLOCKED: IsSpectating unreadable; no second native BeginSpectate'
        end
        if already==true then
            base.native_reused=true
            log('CVG_HANDOFF_REUSED_GAME_SPECTATE: native spectator already active; no duplicate BeginSpectate; original_human_tracked=true')
            return 'CVGSPEC_REUSED_GAME_SPECTATE: already native; use camera RPC and then CAMPAL; no duplicate BeginSpectate'
        end
        base.native_reused=false
        local invoked=pcall(function()pc:BeginSpectate(true)end)
        if not invoked then
            cam_baseline=nil;cam_previous=nil;cam_sync=nil
            return 'CVGSPEC_START_FAILED: BeginSpectate(true) Lua exception; use normal human controls'
        end
        return 'CVGSPEC_START_CALLED: BeginSpectate(true) once; move camera at least 1m; Xbox state unverified'
    end
    if not cam_baseline or not cam_baseline.cvg_spectate or not cam_baseline.pc or
       actor_key(pc)~=cam_baseline.pc_key then
        return 'CVGSPEC_END_BLOCKED: no matching owned CVG spectator session; use game spectate exit if necessary'
    end
    local invoked=pcall(function()pc:EndSpectate()end)
    if not invoked then return 'CVGSPEC_END_FAILED: native EndSpectate exception; session retained; inspect before retry' end
    local base=cam_baseline
    local ok,pawn=pcall(function()return pc:K2_GetPawn()end)
    if not ok or actor_key(pawn)~=base.human_key then
        return 'CVGSPEC_END_UNCONFIRMED: EndSpectate called but original human NOT verified; do not possess; inspect Xbox'
    end
    cam_baseline=nil;cam_previous=nil;cam_sync=nil
    return 'CVGSPEC_END_OK: native EndSpectate called and EXACT original human pawn verified; Xbox camera still needs visual confirmation'
end

camera_action=function(action)
    if pal_control.handoff_pending then return 'CAM_BLOCKED: camera_handoff_pending; no second spectator operation' end
    local pc,player_count,reason=owner_and_count()
    if not pc then return 'CAM_BLOCKED: owner admin unavailable: '..tostring(reason)..'; no_actor_modified=true' end
    if action=='CAMARM' and (trial or recovery_lock or ghost or ai_postcheck_pending or ai_recovery_uncertain) then
        local ready,why=auto_retrial_prepare('camarm')
        if not ready then return 'CAM_RETRY_NEEDS_HUMAN: '..tostring(why) end
    end
    if trial or recovery_lock then
        return 'CAM_RETRY_NEEDS_HUMAN: still controlling previous target; safe return required'
    end
    local pc_key=actor_key(pc)
    if not pc_key then return 'CAM_BLOCKED: no native owner identity; no_actor_modified=true' end
    if action=='CAMARM' then
        local ok,pawn=pcall(function()return pc:K2_GetPawn()end)
        if not ok or not valid(pawn) or pawn:HasAuthority()~=true then
            return 'CAMARM_BLOCKED: human pawn unavailable; exit /spectate first; no_actor_modified=true'
        end
        local cls=pawn_class_name(pawn)
        local low=cls and cls:lower() or ''
        if cls==nil or low:find('spectator',1,true) or low:find('camera',1,true)
          or not low:find('player',1,true) then
            return 'CAMARM_BLOCKED: avatar not confidently human; no_actor_modified=true'
        end
        local pos=cam_geo(pawn)
        if not pos then return 'CAMARM_BLOCKED: avatar position invalid; no_actor_modified=true' end
        -- v1.11.11.11: CAMARM + /ToggleSpectate nativo tambem precisa
        -- registrar ANTES o componente do jogador; anteriormente somente
        -- CVGSPEC guardava a chave, impedindo a leitura do RPC do Xbox.
        local comp_ok,comp=pcall(function()return pc:GetPalSpectateComponent()end)
        if not comp_ok or not valid(comp) then
            comp_ok,comp=pcall(function()return pc.SpectateComponent end)
        end
        local ck=comp_ok and actor_key(comp) or nil
        cam_baseline={pc_key=pc_key,human_key=actor_key(pawn),human_class=cls,
            human=pawn,pos=pos,pc=pc,owner_guid=owner_guid(),
            spectator_component_key=ck,cvg_spectate=false,native_reused=false}
        cam_previous=nil
        cam_sync=nil
        log('CAMPAL_V11111_CAMARM: native_spectator_component_found='..tostring(ck~=nil)..'; Xbox_RPC_delivery_NOT_PROVEN=true; no_actor_modified=true')
        return 'CAMARM_OK: original human saved; native_rpc_component='..tostring(ck~=nil)..'; enter /ToggleSpectate or !cvg espectar, move camera >=1m, then CAM and CAMCHECKPAL; no actor modified'
    end
    if not cam_baseline then
        return 'CAM_BLOCKED: use !cvg camarm BEFORE /spectate; no_actor_modified=true'
    end
    if cam_baseline.pc_key~=pc_key then
        cam_baseline=nil;cam_previous=nil
        return 'CAM_BLOCKED: controller changed after reconnection; baseline erased; no_actor_modified=true'
    end
    local actor,source,pawn,spect,vt=cam_detect(pc)
    local pos=nil
    local rpc=cam_sync
    local rpc_ok=cam_baseline.spectator_component_key and rpc and
        rpc.pc_key==pc_key and rpc.component_key==cam_baseline.spectator_component_key and
        os.time()-rpc.at>=0 and os.time()-rpc.at<=SPECTATOR_SYNC_MAX_AGE_SEC
    if rpc_ok then
        pos=rpc.pos;source='native_server_spectator_rpc'
    else
        if not valid(actor) then
            log('CAMPAL_V11111_NO_SERVER_CAMERA: native_rpc_component='..tostring(cam_baseline.spectator_component_key~=nil)..'; last_authenticated_rpc='..tostring(cam_sync~=nil)..'; no_fresh_server_spectator_actor=true; no_actor_modified=true')
            return 'CAM_UNAVAILABLE: no fresh Xbox spectator RPC or SERVER spectator pawn; use CAMARM before /ToggleSpectate, or !cvg espectar, and move >=1m; if repeated camera is client-only; no_actor_modified=true'
        end
        pos=cam_geo(actor)
    end
    if not pos then return 'CAM_UNAVAILABLE: spectator position not readable; no_actor_modified=true' end
    local ok,r=pcall(function() return pc:GetControlRotation() end)
    local yaw=ok and r and normalize_angle_precise(r.Yaw) or nil
    local pitch=ok and r and normalize_angle_precise(r.Pitch) or nil
    local rotation_readable=(yaw~=nil and pitch~=nil)
    if not rotation_readable then yaw,pitch=0,0 end -- direction only used in old CAMCHECK diagnostic, not camera-possession selector
    local dist_human=cam_delta(pos,cam_baseline.pos)
    local movement=cam_delta(pos,cam_previous and cam_previous.pos or nil)
    local previous=cam_previous
    local actor_id=rpc_ok and cam_baseline.spectator_component_key or actor_key(actor)
    local moved_same_camera=previous and previous.pc_key==pc_key and
        previous.actor_key==actor_id and movement and movement>=CAMERA_MOTION_MIN_CM
    local motion_seen=not not ((rpc_ok and rpc.motion_seen) or moved_same_camera or
        (previous and previous.actor_key==actor_id and previous.motion_seen))
    cam_previous={pos=pos,kind=source,pc_key=pc_key,actor_key=actor_id,
        motion_seen=motion_seen,at=os.time()}
    local summary=string.format('camera_source=%s; camera_from_human_m=%.1f; camera_moved_since_prev_m=%s; ctrl_yaw=%d; ctrl_pitch=%d; camera_rotation_not_verified=true; verified_motion=%s; no_actor_modified=true',source,dist_human/100,movement and string.format('%.1f',movement/100) or 'first_reading',yaw,pitch,tostring(motion_seen))
    if action=='CAM' then
        return 'CAM_PROBE_OK: '..summary
    end
    -- Busca SOMENTE LEITURA e executada uma vez sob demanda. Nao e raycast;
    -- distancia e angulo sao calculados por geometria do espectador NO SERVIDOR.
    if type(FindObjects)~='function' or not EObjectFlags or not EObjectFlags.RF_NoFlags or not EObjectFlags.RF_ClassDefaultObject then
        return 'CAMCHECK_BLOCKED: bounded object scan unavailable; '..summary
    end
    local found=FindObjects(CAM_CHECK_MAX_OBJECTS,'PalCharacter',nil,
        EObjectFlags.RF_NoFlags,EObjectFlags.RF_ClassDefaultObject,false) or {}
    if #found>=CAM_CHECK_MAX_OBJECTS then
        return 'CAMCHECK_BLOCKED: Pal sample reached cap 128, cannot select reliably; '..summary
    end
    local yr,pr=math.rad(yaw),math.rad(pitch)
    local fx,fy,fz=math.cos(pr)*math.cos(yr),math.cos(pr)*math.sin(yr),math.sin(pr)
    local nearest=nil
    local within,inside=0,0
    for _,pal in ipairs(found) do
        local ok_scan,entry=pcall(function()
            if not valid(pal) or pal:HasAuthority()~=true then return nil end
            local cn=pawn_class_name(pal)
            local low=cn and cn:lower() or ''
            if cn==nil or low:find('player',1,true) or low:find('boss',1,true)
              or low:find('raid',1,true) or low:find('tower',1,true)
              or low:find('npc',1,true) or low:find('human',1,true)
              or low:find('trainer',1,true) or low:find('zoe',1,true)
              or low:find('victor',1,true) then return nil end
            local ai=pal.Controller
            if not valid(ai) or ai:HasAuthority()~=true then return nil end
            local ac=pawn_class_name(ai)
            if not ac or not ac:find('Wild',1,true) then return nil end
            local v=cam_geo(pal)
            if not v then return nil end
            local dx,dy,dz=v.x-pos.x,v.y-pos.y,v.z-pos.z
            local d=math.sqrt(dx*dx+dy*dy+dz*dz)
            if not num_in_range(d,1e8) or d<20 or d>CAM_CHECK_MAX_DISTANCE_CM then return nil end
            local dot=math.max(-1,math.min(1,(dx*fx+dy*fy+dz*fz)/d))
            local angle=math.deg(math.acos(dot))
            if not num_in_range(angle,180.01) then return nil end
            return {distance=d,angle=angle,class=cn}
        end)
        if ok_scan and entry then
            within=within+1
            if entry.angle<=CAM_CHECK_CONE_DEG then
                inside=inside+1
                if not nearest or entry.angle<nearest.angle then nearest=entry end
            end
        end
    end
    if not nearest then
        return string.format('CAMCHECK_NO_TARGET: wild_within_30m=%d; in_20deg_cone=0; rotation/client camera unverified; %s',within,summary)
    end
    local palclass=nearest.class:gsub('[^%w_]',''):sub(1,40)
    return string.format('CAMCHECK_CANDIDATE: pal=%s; camera_distance_m=%.1f; camera_angle_deg=%.1f; in_20deg_cone=%d; sample_size=%d; READ_ONLY_NOT_POSSESSABLE_YET; %s',palclass,nearest.distance/100,nearest.angle,inside,#found,summary)
end

-- v1.10.8: preflight da camera do espectador. NUNCA aceita camera somente no Xbox.
-- Mantem referenciados o humano original e o PC com GUID do dono.
 -- Nenhuma mutation nem selecao global aqui. Usado por CAMCHECKPAL/CAMCHECKNPC
 -- e CAMPAL/CAMNPC; ao falhar nenhuma chamada nativa Possess ocorre.
local function camera_possession_origin(pc)
    if not cam_baseline then return nil,'CAMARM_REQUIRED: arm while still human' end
    local pc_id=actor_key(pc)
    if not pc_id or pc_id~=cam_baseline.pc_key then
        cam_baseline=nil;cam_previous=nil
        return nil,'CONTROLLER_CHANGED: reconnect requires fresh CAMARM'
    end
    local human=cam_baseline.human
    if not valid(human) or actor_key(human)~=cam_baseline.human_key or
       pawn_class_name(human)~=cam_baseline.human_class or
       not cam_baseline.human_class:match('^BP_Player_[%w_]+_C$') then
        return nil,'HUMAN_CHANGED: cannot safely restore original pawn'
    end
    local ok_human,alive=pcall(function()
        local param=human.CharacterParameterComponent
        return human:HasAuthority()==true and valid(param) and param:IsDead()==false
    end)
    if not ok_human or not alive then return nil,'HUMAN_DEAD_OR_NONAUTHORITY' end
    local human_pos=cam_geo(human)
    if not human_pos or not cam_baseline.pos then
        return nil,'ORIGINAL_HUMAN_UNREADABLE: cannot guarantee return'
    end
    if (cam_delta(human_pos,cam_baseline.pos) or 0)>CAMERA_HUMAN_MAX_DRIFT_CM then
        -- Mesmo ator original, vida/autoridade/controle comprovados acima.
        -- Distancia anterior nao deve criar bloqueio permanente ao retestar.
        log('RETRY_HUMAN_POSITION_REBASE: original_human_native_identity_unchanged=true; spectator baseline updated; no pawn mutation')
        cam_baseline.pos=human_pos
    end
    local c_ok,existing_controller=pcall(function() return human.Controller end)
    if not c_ok or (valid(existing_controller) and actor_key(existing_controller)~=pc_id) then
        return nil,'HUMAN_CONTROLLED_BY_ANOTHER_CONTROLLER'
    end
    -- Novo modo nativo: o cliente Xbox informa localizacao ao servidor
    -- via RPC ServerSyncSpectatorLocation, no componente do owner autenticado.
    -- So aceitar amostra recente + movimento >=1m + IsSpectating confirmado.
    local sync=cam_sync
    if cam_baseline.spectator_component_key and sync and sync.pc_key==pc_id and
       sync.component_key==cam_baseline.spectator_component_key then
        local now=os.time()
        local ok_s,inspec=pcall(function()return pc:IsSpectating()end)
        if not ok_s or inspec~=true then
            local ok_sc,component=pcall(function()return pc:GetPalSpectateComponent()end)
            ok_s,inspec=pcall(function()return ok_sc and valid(component) and component:IsSpectating()end)
        end
        if not ok_s or inspec~=true then return nil,'CVGSPEC_SERVER_SPECTATE_STATE_UNCONFIRMED' end
        if not sync.motion_seen or now-sync.at<0 or now-sync.at>SPECTATOR_SYNC_MAX_AGE_SEC then
            return nil,'CVGSPEC_CAMERA_RPC_STALE_OR_STATIC: move camera >=1m and retry within 45s'
        end
        if (cam_delta(sync.pos,human_pos) or 0)<300 then
            return nil,'CVGSPEC_CAMERA_TOO_CLOSE: move camera at least 3m away from human'
        end
        return {human=human,pos=sync.pos,camera=nil,camera_kind='native_server_spectator_rpc',
            camera_key=sync.component_key,human_key=cam_baseline.human_key,
            aim_verified=sync.aim_verified==true,yaw=sync.yaw,pitch=sync.pitch,
            cvg_native=true,native_reused=cam_baseline.native_reused==true,server_sync_at=sync.at}
    end
    local camera,kind,pawn=cam_detect(pc)
    if not valid(camera) or not kind or
       actor_key(camera)==cam_baseline.human_key then
        return nil,'SERVER_SPECTATOR_NOT_PROVEN: no verified server spectator actor or Xbox RPC; camera may be client-only'
    end
    -- O /ToggleSpectate pode deixar K2_GetPawn apontando para o humano,
    -- embora GetSpectatorPawn/GetViewTarget exponha uma camera no servidor.
    -- Exigir IsSpectating, camera distinta com autoridade e CAMs mostrando
    -- movimento; nunca aceitar a posicao do humano como camera.
    local spectating_ok,spectating=pcall(function()return pc:IsSpectating()end)
    if not spectating_ok or spectating~=true then
        return nil,'SERVER_SPECTATE_STATE_UNCONFIRMED: no camera possession'
    end
    if camera:HasAuthority()~=true then
        return nil,'SERVER_CAMERA_NOT_AUTHORITATIVE: no camera possession'
    end
    local pawn_key=actor_key(pawn)
    if pawn_key~=cam_baseline.human_key then
        local pawn_class=pawn_class_name(pawn) or ''
        local pawn_low=pawn_class:lower()
        if not valid(pawn) or not (pawn_low:find('spectator',1,true) or
                pawn_low:find('camera',1,true) or actor_key(pawn)==actor_key(camera)) then
            return nil,'SPECTATOR_PAWN_UNVERIFIED: do not hijack a normal pawn'
        end
    else
        if kind~='spectator_pawn' and kind~='spectator_view_target' then
            return nil,'HUMAN_PAWN_WITHOUT_VERIFIED_SERVER_CAMERA: no camera possession'
        end
        log('CAMPAL_V11111_SPECTATOR_CAMERA_WITH_HUMAN_PAWN: server_camera_separate=true; IsSpectating=true; CAM_motion_still_required=true; no_actor_modified=true')
    end
    local pos=cam_geo(camera)
    local camera_id=actor_key(camera)
    if not pos or not camera_id then return nil,'SERVER_CAMERA_COORDINATES_UNREADABLE' end
    if (cam_delta(pos,human_pos) or 0)<300 then
        return nil,'CAMERA_TOO_CLOSE_TO_ORIGINAL_HUMAN: move spectator camera first'
    end
    local probe=cam_previous
    local now=os.time()
    if not probe or probe.pc_key~=pc_id or probe.actor_key~=camera_id or
       probe.motion_seen~=true or type(now)~='number' or
       type(probe.at)~='number' or now-probe.at<0 or now-probe.at>CAMERA_PROBE_MAX_AGE_SEC then
        return nil,'CAMERA_NOT_VERIFIED_MOVING_ON_SERVER: use CAM at two positions within 30s'
    end
    -- Amostras atuais: bloquear se deslocamento entre ultimo CAM e selecao >15m.
    if (cam_delta(pos,probe.pos) or math.huge)>1500 then
        return nil,'CAMERA_MOVED_AFTER_PROBE: repeat CAM near target'
    end
    return {human=human,pos=pos,camera=camera,camera_kind=kind,
        camera_key=camera_id,human_key=cam_baseline.human_key}
end

-- Diagnostico somente da posicao de DOIS atores previamente rastreados;
-- nenhuma varredura do mundo, nenhum deslocamento de humano ou Pal.
local function range_probe_schedule(state,step)
    if not state or step>RANGE_PROBE_MAX_SAMPLES or type(ExecuteWithDelay)~='function' then return end
    local queued=pcall(function()
        ExecuteWithDelay(RANGE_PROBE_STEP_MS,function()
            if trial~=state or state.restoring then return end
            local dispatched=pcall(function()
                ExecuteInGameThread(function()
                    if trial~=state or state.restoring then return end
                    local ok,dist=pcall(function()
                        if not valid(state.pal) or not valid(state.human) then return nil end
                        local a=state.pal:K2_GetActorLocation()
                        local b=state.human:K2_GetActorLocation()
                        if not a or not b then return nil end
                        local dx,dy,dz=a.X-b.X,a.Y-b.Y,a.Z-b.Z
                        local d=math.sqrt(dx*dx+dy*dy+dz*dz)/100
                        if d~=d or d<0 or d>100000 then return nil end
                        return d
                    end)
                    -- Sem avisos no chat para nao criar trafego a cada 10s.
                    if ok and dist then
                        print(string.format('[CVG Boss Control v%s] RANGE_SAMPLE: step=%d; pal_to_human_m=%.1f; boost=%s; read_only=true\n',VERSION,step,dist,tostring(state.range_applied==true)))
                    else
                        print('[CVG Boss Control v'..VERSION..'] RANGE_SAMPLE_UNAVAILABLE: actor invalid or no location\n')
                    end
                    if step<RANGE_PROBE_MAX_SAMPLES then range_probe_schedule(state,step+1) end
                end)
            end)
            if not dispatched then log('RANGE_SAMPLE_STOPPED: game-thread dispatch unavailable') end
        end)
    end)
    if not queued then log('RANGE_SAMPLE_STOPPED: delay unavailable') end
end
-- v1.9.0: diagnostico sob demanda, SOMENTE LEITURA durante a possessao.
-- Compara onde o Unreal ve o foco do PlayerController com o Pal e o humano.
-- Nao move nenhum personagem; nao altera relevancia, streaming, saves ou IA.
-- Nao executa buscas de atores; confere apenas referencias ja rastreadas.
local function focus_action()
    if not trial or trial.restoring then
        return 'FOCUS_BLOCKED: no active stable trial; no actor modified'
    end
    local state=trial
    local pc,_,reason=owner_and_count()
    if not pc or not state.pc_key or actor_key(pc)~=state.pc_key then
        return 'FOCUS_BLOCKED: verified original controller unavailable; no actor modified'
    end
    if not valid(state.human) or not valid(state.pal) then
        return 'FOCUS_UNAVAILABLE: tracked human or Pal not valid; no actor modified'
    end
    local okp,pawn=pcall(function()return pc:K2_GetPawn()end)
    if not okp or not valid(pawn) or actor_key(pawn)~=state.pal_key then
        return 'FOCUS_BLOCKED: original owner no longer possesses tracked Pal; no actor modified'
    end
    local hp=cam_geo(state.human)
    local pp=cam_geo(state.pal)
    if not hp or not pp then return 'FOCUS_UNAVAILABLE: actor coordinates unavailable; no actor modified' end
    local pal_distance=(cam_delta(hp,pp) or 0)/100
    -- GetFocalLocation e UFUNCTION oficial de APlayerController; falha => indisponivel.
    local ok_f,focal=pcall(function()return pc:GetFocalLocation()end)
    local fp=nil
    if ok_f and focal then
        local x,y,z=focal.X,focal.Y,focal.Z
        if num_in_range(x,1e8) and num_in_range(y,1e8) and num_in_range(z,1e8) then
            fp={x=x,y=y,z=z}
        end
    end
    local ok_v,target=pcall(function()return pc:GetViewTarget()end)
    local target_key=ok_v and valid(target) and actor_key(target) or nil
    local vt='unavailable'
    if target_key then
        vt=(target_key==state.pal_key and 'pal') or (target_key==actor_key(state.human) and 'human') or 'other'
    end
    local speed='unavailable'
    local ok_s,vel=pcall(function()return state.pal:GetVelocity()end)
    if ok_s and vel and num_in_range(vel.X,1e6) and num_in_range(vel.Y,1e6) and num_in_range(vel.Z,1e6) then
        speed=string.format('%.1f', math.sqrt(vel.X*vel.X+vel.Y*vel.Y+vel.Z*vel.Z))
    end
    local tick='unavailable'
    local ok_t,on=pcall(function()return state.pal:IsActorTickEnabled()end)
    if ok_t and type(on)=='boolean' then tick=tostring(on) end
    local focal_to_pal=fp and string.format('%.1f',(cam_delta(fp,pp) or 0)/100) or 'unavailable'
    local focal_to_human=fp and string.format('%.1f',(cam_delta(fp,hp) or 0)/100) or 'unavailable'
    return string.format('FOCUS_DIAG: pal_to_human_m=%.1f; focus_to_pal_m=%s; focus_to_human_m=%s; view_target=%s; controlled_pawn=pal; pal_velocity_cm_s=%s; pal_tick=%s; boost=%s; READ_ONLY=true; NO_ACTOR_MODIFIED=true',
        pal_distance,focal_to_pal,focal_to_human,vt,speed,tick,tostring(state.range_applied==true))
end
-- v1.9.1: hipótese direcionada à perda de animação no XBOX com movimento ainda funcional.
-- A função de rede ClientRestart(APawn*) da Unreal pede ao cliente dono que
-- reinicialize o pawn já possuído. A função não é exclusiva do Palworld;
-- disponibilidade e utilidade precisam ser verificadas em teste controlado.
-- Nunca é chamada automaticamente. Só 1 tentativa por possessão, via TXT,
-- e SOMENTE com o mesmo PlayerController/Pawn originais validados no servidor.
-- O RPC pode desorganizar input/câmera Xbox: retornar usando 3 pulos/TXT RETURN.
local function resync_action()
    if not trial or trial.restoring or trial_op_busy==false then
        return 'RESYNC_BLOCKED: no active stable trial; no RPC sent'
    end
    local state=trial
    if state.offline or state.pal_lost or not state.controlled or state.resync_attempted then
        return 'RESYNC_BLOCKED: offline/lost/unverified or already attempted in this trial; no RPC sent'
    end
    local pc,count,reason=owner_and_count()
    if not pc or not state.pc_key or actor_key(pc)~=state.pc_key or not valid(state.pal) or not valid(state.human) then
        return 'RESYNC_BLOCKED: original owner/admin or tracked pawn unavailable; no RPC sent'
    end
    local ok,pawn=pcall(function()return pc:K2_GetPawn()end)
    if not ok or not valid(pawn) or not state.pal_key or actor_key(pawn)~=state.pal_key then
        return 'RESYNC_BLOCKED: current pawn is not tracked Pal; no RPC sent'
    end
    local pal_controller_ok,pal_controller=pcall(function()return state.pal.Controller end)
    if not pal_controller_ok or not valid(pal_controller) or actor_key(pal_controller)~=state.pc_key then
        return 'RESYNC_BLOCKED: tracked Pal not controlled by original owner; no RPC sent'
    end
    -- Limite de uma tentativa: bloquear até mesmo se a UFUNCTION falhar.
    -- pcall captura erros Lua, mas NAO evita crash nativo dentro do motor.
    state.resync_attempted=true
    log('RESYNC_STAGE_1: exact original owner/pal confirmed; ClientRestart(Pal) RPC='..(state.auto_resync_requested and 'AUTO_55M' or 'MANUAL')..'; Xbox reception unverified')
    local invoked=pcall(function()
        if state.direct_control then
            pc:ClientRetryClientRestart(state.pal)
            pal_control.set_view(pc,state.pal)
        else pc:ClientRestart(state.pal) end
    end)
    if not invoked then
        return 'RESYNC_UNAVAILABLE: native ClientRestart RPC failed or is not exposed in this server; do not retry in same trial; TXT RETURN still available'
    end
    local after_ok,after=pcall(function()return pc:K2_GetPawn()end)
    if not after_ok or not valid(after) or actor_key(after)~=state.pal_key then
        return 'RESYNC_UNCERTAIN: RPC attempted; server current pawn changed unexpectedly; use TXT RETURN and inspect before next trial'
    end
    return 'RESYNC_RPC_SENT: ClientRestart(Pal) invoked once for this owner; does NOT prove Xbox animation fixed; report visual result, then return normally'
end

-- v1.10.0: one existing Wild Pal; documented UE RPCs, no body-follow proxy.
-- Server checks cannot prove Xbox input, animation or world streaming.
-- This table is forward-declared before restore_trial in the main chunk.
pal_control.last_sequence=0
pal_control.monitor_busy=false
pal_control.pending_restore=nil
function pal_control.target_kind(actor)
    local ok,kind=pcall(function()
        if not valid(actor) or actor:HasAuthority()~=true or actor:IsPlayerControlled()~=false then return nil end
        local base=StaticFindObject('/Script/Pal.PalNPC')
        local monster=StaticFindObject('/Script/Pal.PalMonsterCharacter')
        local player=StaticFindObject('/Script/Pal.PalPlayerCharacter')
        if not valid(base) or not valid(monster) or not valid(player) then return nil end
        if not actor:IsA(base) or actor:IsA(player) then return nil end
        local param=actor.CharacterParameterComponent
        local static=actor.StaticCharacterParameterComponent
        if not valid(param) or not valid(static) or param:IsDead()~=false then return nil end
        if static.IsPal==true and actor:IsA(monster) then return 'PAL' end
        if static.IsPal==false and not actor:IsA(monster) then return 'NPC' end
        return nil
    end)
    return ok and kind or nil
end
-- v1.11.7: CAMPAL agora aceita Pals Alpha/BOSS e CAMBOSS filtra somente
-- boss Pals. Nao confundir PalBoss com jogador, NPC humano, raid/tower,
-- summon ou boss de treinador: scripts de arena podem mudar estado do mundo.
-- O controller ORIGINAL precisa ser uma IA de Pal Wild ou Boss nativa.
-- Nao aceita controllers de jogadores, Otomo, BaseCamp, Raid ou Tower.
local function cvg_pal_camera_candidate(class_name,ai_name,npc_mode,boss_only)
    if type(class_name)~='string' or type(ai_name)~='string' then return false,false end
    local cn=class_name:lower()
    local ai=ai_name:lower()
    for _,part in ipairs({'player','raid','tower','summon','trainer','zoe','victor'}) do
        if cn:find(part,1,true) then return false,false end
    end
    for _,part in ipairs({'player','basecamp','otomo','raid','tower','trainer'}) do
        if ai:find(part,1,true) then return false,false end
    end
    local is_boss=cn:find('boss',1,true)~=nil
    if npc_mode then return not boss_only,false end
    if boss_only and not is_boss then return false,false end
    local allowed_ai=ai:find('wild',1,true)~=nil or
        (is_boss and ai:find('boss',1,true)~=nil)
    return allowed_ai,is_boss
end

function pal_control.api(path)
    if type(StaticFindObject)~='function' then return false end
    local ok,fn=pcall(function() return StaticFindObject(path) end)
    return ok and valid(fn)
end
function pal_control.snapshot(pc,human,pal)
    local cls=pawn_class_name(human)
    if not cls or not cls:match('^BP_Player_[%w_]+_C$') then
        return nil,'original_pawn_not_human'
    end
    local life_ok,alive=pcall(function()
        local parameter=human.CharacterParameterComponent
        return valid(parameter) and parameter:IsDead()==false
    end)
    if not life_ok or not alive then return nil,'original_human_dead_or_unreadable' end
    local ok,s=pcall(function()
        local r={attach=pc.bAttachToPawn,auto=pc.bAutoManageActiveCameraTarget,
            streaming=pc.bEnableStreamingSource,hidden=human.bHidden,
            always=pal.bAlwaysRelevant,movement=pal.bReplicateMovement,
            active=pal:GetActiveActorFlag(),tick=pal:IsActorTickEnabled(),interval=pal:GetActorTickInterval(),
            pc_key=actor_key(pc),human_key=actor_key(human),pal_key=actor_key(pal)}
        if type(r.attach)~='boolean' or type(r.auto)~='boolean' or
           type(r.hidden)~='boolean' or type(r.always)~='boolean' or
           type(r.movement)~='boolean' or r.active~=true or type(r.tick)~='boolean' or
           type(r.interval)~='number' or r.interval~=r.interval or r.interval<0 or r.interval>60 or
           not r.pc_key or not r.human_key or not r.pal_key then
            return nil
        end
        -- Snapshot OPCIONAL: API de rede pode mudar apos update do Palworld.
        -- Se nao for legivel, manter o modo de posse antigo sem bloquear
        -- TODOS os NPCs/Pals. Nunca escrever flags sem saber restaurar.
        local net_ok,n_cull,n_only,n_owner,n_hz,n_min=pcall(function()
            return pal.NetCullDistanceSquared,pal.bOnlyRelevantToOwner,
                pal.bNetUseOwnerRelevancy,pal.NetUpdateFrequency,pal.MinNetUpdateFrequency
        end)
        if net_ok and type(n_cull)=='number' and n_cull>=0 and n_cull<1e16 and n_cull==n_cull
            and type(n_only)=='boolean' and type(n_owner)=='boolean' and
            type(n_hz)=='number' and n_hz>0 and n_hz<=1000 and n_hz==n_hz and
            type(n_min)=='number' and n_min>=0 and n_min<=1000 and n_min==n_min then
            r.net_ready=true;r.net_cull=n_cull;r.net_only_owner=n_only
            r.net_use_owner=n_owner;r.net_update=n_hz;r.net_min_update=n_min
        else
            r.net_ready=false
        end
        -- A hidden human may be in CVGMetamorfose. Never combine sessions.
        if r.hidden then return nil end
        r.flag=FName('CVGDirectPossession_v110')
        if not r.flag or r.flag:ToString()~='CVGDirectPossession_v110' then return nil end
        return r
    end)
    if not ok or not s then return nil,'baseline_unreadable_or_human_hidden' end
    for _,path in ipairs({
        '/Script/Engine.PlayerController:ClientRetryClientRestart',
        '/Script/Engine.PlayerController:ClientSetViewTarget',
        '/Script/Engine.PlayerController:SetViewTargetWithBlend',
        '/Script/Engine.Actor:SetActorHiddenInGame',
        '/Script/Pal.PalCharacter:SetDisableChangeIntervalByImportance',
        '/Script/Pal.PalCharacter:SetActiveActor',
        '/Script/Engine.Actor:SetActorTickEnabled',
        '/Script/Engine.Actor:SetActorTickInterval'}) do
        if not pal_control.api(path) then return nil,'required_native_api_unavailable' end
    end
    return s
end
function pal_control.exact(state,require_pal)
    if not state or state.offline or not valid(state.pc) or
       actor_key(state.pc)~=state.pc_key then return false end
    local ok,authorized=pcall(function()
        return state.pc:HasAuthority()==true and state.pc.bAdmin==true
            and guid(state.pc:GetPlayerUId())==owner_guid()
    end)
    if not ok or not authorized then return false end
    if not require_pal then return true end
    if not valid(state.pal) or actor_key(state.pal)~=state.pal_key then return false end
    local read,pawn,controller=pcall(function()
        return state.pc:K2_GetPawn(),state.pal.Controller
    end)
    return read and actor_key(pawn)==state.pal_key and actor_key(controller)==state.pc_key
end
function pal_control.set_view(pc,target)
    -- Use UE's real client RPC. A server-only view target is insufficient.
    pc:SetViewTargetWithBlend(target,0,0,0,false)
    pc:ClientSetViewTarget(target,{BlendTime=0,BlendFunction=0,BlendExp=0,bLockOutgoing=false})
end
-- Unreal expõe valores de replicação em float32; Lua usa doubles.
-- Um pedido de 90_000_000_000 cm2 volta como 89_999_998_976 cm2;
-- comparar com >= exato derruba a posse apesar do readback valido.
-- Margem somente NUMERICA (~0.00003%): nao afrouxa Pawn/Controller,
-- autoridade, identidade, captura, tick ou retorno do humano.
function pal_control.net_float_at_least(actual,required)
    return type(actual)=='number' and type(required)=='number'
        and actual==actual and required==required and actual>=0 and required>=0
        and actual<1e16 and required<1e16
        and actual+math.max(0.00001,required*0.0000003)>=required
end
function pal_control.readback_diagnostic(state,s)
    -- Somente quando setup falhou. Sem gravar ID de usuario ou objeto.
    local checks={}
    local function check(name,fn)
        local ok,val=pcall(fn)
        checks[#checks+1]=name..'='..(ok and tostring(val) or 'UNREADABLE')
    end
    check('exact_original_possession',function()return pal_control.exact(state,true)end)
    check('attach',function()return state.pc.bAttachToPawn==true end)
    check('auto_camera',function()return state.pc.bAutoManageActiveCameraTarget==true end)
    check('streaming',function()return type(s.streaming)~='boolean' or state.pc.bEnableStreamingSource==true end)
    check('always_relevant',function()return state.pal.bAlwaysRelevant==true end)
    check('replicate_movement',function()return state.pal.bReplicateMovement==true end)
    check('net_ready',function()return s.net_ready end)
    if s.net_ready then
        local cull=math.max(s.net_cull,pal_control.possession_net_cull_cm(state)*pal_control.possession_net_cull_cm(state))
        local hz=math.max(s.net_update,s.net_min_update,POSSESSION_NET_UPDATE_HZ)
        local minhz=math.max(s.net_min_update,POSSESSION_NET_MIN_HZ)
        check('net_cull_read',function()return state.pal.NetCullDistanceSquared end)
        check('net_cull_requested',function()return cull end)
        check('net_cull_ok',function()return pal_control.net_float_at_least(state.pal.NetCullDistanceSquared,cull)end)
        check('net_hz_read',function()return state.pal.NetUpdateFrequency end)
        check('net_hz_requested',function()return hz end)
        check('net_hz_ok',function()return pal_control.net_float_at_least(state.pal.NetUpdateFrequency,hz)end)
        check('net_min_hz_ok',function()return pal_control.net_float_at_least(state.pal.MinNetUpdateFrequency,minhz)end)
        check('net_only_owner_off',function()return state.pal.bOnlyRelevantToOwner==false end)
        check('net_use_owner_off',function()return state.pal.bNetUseOwnerRelevancy==false end)
    end
    check('pal_active',function()return state.pal:GetActiveActorFlag()==true end)
    check('pal_tick',function()return state.pal:IsActorTickEnabled()==true end)
    check('pal_interval_zero',function()return state.pal:GetActorTickInterval()==0 end)
    check('human_hidden',function()return state.human.bHidden==true end)
    check('server_view_target_pal',function()return actor_key(state.pc:GetViewTarget())==state.pal_key end)
    log('PAL_CONTROL_READBACK_DIAG: '..table.concat(checks,'; ')..'; fails_closed=true')
end
function pal_control.apply(state)
    if not state.focus_baseline or not pal_control.exact(state,true) then
        return false,'original_possession_not_verified'
    end
    local s=state.focus_baseline
    state.focus_dirty=true -- BEFORE the first write; partial failures require rollback.
    local ok=pcall(function()
        state.pc.bAttachToPawn=true
        state.pc.bAutoManageActiveCameraTarget=true
        if type(s.streaming)=='boolean' then state.pc.bEnableStreamingSource=true end
        -- Salvaram-se TODOS os valores antes do Possess: desligar apenas as
        -- regras de relevancia dependentes do Owner do proprio alvo. O alvo
        -- continua possuido pelo controller REAL do admin (necessario para Xbox).
        -- A relevancia nao equivale a manter celulas do mundo carregadas.
        state.pal.bAlwaysRelevant=true
        state.pal.bReplicateMovement=true
        if s.net_ready then
            state.pal.bOnlyRelevantToOwner=false
            state.pal.bNetUseOwnerRelevancy=false
            state.pal.NetCullDistanceSquared=math.max(s.net_cull,pal_control.possession_net_cull_cm(state)*pal_control.possession_net_cull_cm(state))
            state.pal.NetUpdateFrequency=math.max(s.net_update,s.net_min_update,POSSESSION_NET_UPDATE_HZ)
            state.pal.MinNetUpdateFrequency=math.max(s.net_min_update,POSSESSION_NET_MIN_HZ)
        end
        state.pal:SetDisableChangeIntervalByImportance(s.flag,true)
        state.pal:SetActiveActor(true)
        state.pal:SetActorTickEnabled(true)
        state.pal:SetActorTickInterval(0)
        state.pal:ForceNetUpdate()
        -- Idempotent client handshake; does not overwrite AcknowledgedPawn.
        state.pc:ClientRetryClientRestart(state.pal)
        pal_control.set_view(state.pc,state.pal)
        state.human:SetActorHiddenInGame(true)
        state.human:ForceNetUpdate()
    end)
    if not ok then return false,'native_setup_error' end
    local checked,confirmed=pcall(function()
        return pal_control.exact(state,true)
            and state.pc.bAttachToPawn==true
            and state.pc.bAutoManageActiveCameraTarget==true
            and (type(s.streaming)~='boolean' or state.pc.bEnableStreamingSource==true)
            and state.pal.bAlwaysRelevant==true and state.pal.bReplicateMovement==true
            and (not s.net_ready or (
                state.pal.bOnlyRelevantToOwner==false and state.pal.bNetUseOwnerRelevancy==false
                and pal_control.net_float_at_least(state.pal.NetCullDistanceSquared,math.max(s.net_cull,pal_control.possession_net_cull_cm(state)*pal_control.possession_net_cull_cm(state)))
                and pal_control.net_float_at_least(state.pal.NetUpdateFrequency,math.max(s.net_update,s.net_min_update,POSSESSION_NET_UPDATE_HZ))
                and pal_control.net_float_at_least(state.pal.MinNetUpdateFrequency,math.max(s.net_min_update,POSSESSION_NET_MIN_HZ))))
            and state.pal:GetActiveActorFlag()==true and state.pal:IsActorTickEnabled()==true
            and state.pal:GetActorTickInterval()==0
            and state.human.bHidden==true
            and actor_key(state.pc:GetViewTarget())==state.pal_key
    end)
    if not checked or not confirmed then
        pal_control.readback_diagnostic(state,s)
        return false,'setup_readback_failed'
    end
    state.direct_control=true
    state.direct_started=os.time()
    state.net_last_pulse=os.time()
    state.net_last_diag=0
    log('POSSESSION_NET_ARMED: target_kind='..tostring(state.target_kind)..'; same_actor_only=true; native_net_patch='..tostring(s.net_ready)..'; bAlwaysRelevant=true; cull_target_m='..tostring(pal_control.possession_net_cull_cm(state)/100)..'; net_hz_target=40; 3D_tracking=ON; actor_only_heartbeat_4s=true; no_teleport_no_player_modified=true; world_streaming_XBOX_UNVERIFIED=true')
    log('PAL_CONTROL_SERVER_READY: target_kind='..tostring(state.target_kind)..'; pawn=original_actor; view_target=pal; attach_to_pawn=true; client_retry_rpc_sent=true; no_radius_cutoff=true; manual_return=true; XBOX_INPUT_AND_STREAMING_UNVERIFIED')
    return true
end
function pal_control.restore(state,pc,current)
    if not state or not state.focus_dirty then return true end
    local s=state.focus_baseline
    if not s then return false end
    local restored=true
    local function attempt(fn)
        if not pcall(fn) then restored=false end
    end
    -- Never change a newly connected controller or a different human.
    if valid(pc) and actor_key(pc)==s.pc_key and actor_key(current)==s.human_key then
        attempt(function()
            pc.bAttachToPawn=s.attach
            pc.bAutoManageActiveCameraTarget=s.auto
            if type(s.streaming)=='boolean' then pc.bEnableStreamingSource=s.streaming end
            pc:ClientRetryClientRestart(current)
            pal_control.set_view(pc,current)
            if pc.bAttachToPawn~=s.attach or pc.bAutoManageActiveCameraTarget~=s.auto or
               (type(s.streaming)=='boolean' and pc.bEnableStreamingSource~=s.streaming) then
                error('controller_flags_not_restored')
            end
        end)
    else restored=false end
    -- Visibility belongs to the exact preserved human, not the current spawn.
    if valid(state.human) and actor_key(state.human)==s.human_key then
        attempt(function()
            state.human:SetActorHiddenInGame(s.hidden)
            state.human:ForceNetUpdate()
            if state.human.bHidden~=s.hidden then error('human_visibility_not_restored') end
        end)
    else restored=false end
    if state.pal_lost then
        log('PAL_CONTROL_LOST_TARGET_SKIPPED: no_tick_no_activation_no_visibility_writes_to_dead_or_captured_actor')
    elseif valid(state.pal) and actor_key(state.pal)==s.pal_key then
        attempt(function()
            state.pal.bAlwaysRelevant=s.always
            if s.net_ready then
                state.pal.bOnlyRelevantToOwner=s.net_only_owner
                state.pal.bNetUseOwnerRelevancy=s.net_use_owner
                state.pal.NetCullDistanceSquared=s.net_cull
                state.pal.NetUpdateFrequency=s.net_update
                state.pal.MinNetUpdateFrequency=s.net_min_update
            end
            state.pal.bReplicateMovement=s.movement
            state.pal:SetDisableChangeIntervalByImportance(s.flag,false)
            state.pal:SetActorTickInterval(s.interval)
            state.pal:SetActorTickEnabled(s.tick)
            state.pal:SetActiveActor(s.active)
            state.pal:ForceNetUpdate()
            if state.pal.bAlwaysRelevant~=s.always or state.pal.bReplicateMovement~=s.movement or
               (s.net_ready and (state.pal.bOnlyRelevantToOwner~=s.net_only_owner or
                state.pal.bNetUseOwnerRelevancy~=s.net_use_owner or state.pal.NetCullDistanceSquared~=s.net_cull or
                state.pal.NetUpdateFrequency~=s.net_update or state.pal.MinNetUpdateFrequency~=s.net_min_update)) or
               state.pal:IsActorTickEnabled()~=s.tick or state.pal:GetActorTickInterval()~=s.interval or
               state.pal:GetActiveActorFlag()~=s.active then
                error('pal_network_flags_not_restored')
            end
        end)
    else restored=false end
    if restored then
        state.focus_dirty=false
        if pal_control.pending_restore==state then pal_control.pending_restore=nil end
        log('PAL_CONTROL_RESTORE_OK: exact_original_human_visible; controller_and_pal_flags_restored; client_rpc_sent; Xbox_confirmation_required=true')
    else
        pal_control.pending_restore=state
        log('PAL_CONTROL_RESTORE_PENDING: references_retained=true; new_trials_blocked=true; use_RETURN_after_review')
    end
    return restored
end
function pal_control.check(state)
    if not state or not state.direct_control or state.restoring or state.offline then return end
    if not pal_control.exact(state,true) then
        if not state.control_loss_reported then
            state.control_loss_reported=true
            log('PAL_CONTROL_IDENTITY_LOST: monitor_stopped; no_repossess_no_teleport=true; RETURN_requires_review')
        end
        return
    end
    local ok,view=pcall(function() return state.pc:GetViewTarget() end)
    if not ok or actor_key(view)~=state.pal_key then
        if not state.view_drift_reported then
            state.view_drift_reported=true
            log('PAL_CONTROL_VIEW_DRIFT: controlled_pawn_still_pal; no_automatic_RPC_loop=true; use_FOCUS_or_RESYNC')
        end
    end
    local active_ok,active,ticking=pcall(function()
        return state.pal:GetActiveActorFlag(),state.pal:IsActorTickEnabled()
    end)
    if (not active_ok or active~=true or ticking~=true) and not state.simulation_warned then
        state.simulation_warned=true
        log('PAL_CONTROL_SIMULATION_CHANGED: native_game_changed_active_or_tick; no_unbounded_repair_loop; use_RETURN')
    end
    -- SAFEON opcional verifica SOMENTE os dois atores ja rastreados, a cada 2s.
    -- Nao faz teleport, nao altera mundo, nao mexe em outros jogadores.
    if state.stream_safe and not state.stream_safe_return_requested then
        local hh=cam_geo(state.human)
        local pp=cam_geo(state.pal)
        local dist_cm=cam_delta(hh,pp)
        if dist_cm and dist_cm>=STREAM_SAFE_RETURN_CM then
            state.stream_safe_return_requested=true
            log('STREAM_SAFE_LIMIT_REACHED: optional one-shot return at 170m from original human; cannot guarantee Xbox streaming or movement')
            log(restore_trial('stream_safe_optional_170m'))
            return
        end
    end
    -- Pulso pontual de replicacao, APENAS no mesmo Pawn possuido e apos
    -- revalidar PC, controlador e posse. Nao tenta corrigir perda de identidade
    -- via Possess/RPC repetitivos e nao altera streaming de outros jogadores.
    local now=os.time()
    if type(now)=='number' and now-(state.net_last_pulse or now)>=(state.target_kind=='NPC' and pal_control.NET_NPC_PULSE_SEC or POSSESSION_NET_PULSE_SEC) then
        state.net_last_pulse=now
        local pulse_ok=pcall(function() state.pal:ForceNetUpdate() end)
        if not pulse_ok and not state.net_pulse_warned then
            state.net_pulse_warned=true
            log('POSSESSION_NET_PULSE_UNAVAILABLE: actor only; no forced recovery; manual RETURN remains')
        end
    end
    if type(now)=='number' and now-(state.net_last_diag or 0)>=POSSESSION_NET_DIAG_SEC then
        state.net_last_diag=now
        local h=cam_geo(state.human)
        local p=cam_geo(state.pal)
        if p and state.spec_from_native_game then
            state.spec_pal_last_pos={x=p.x,y=p.y,z=p.z}
            state.spec_pal_last_source='existing_position_monitor'
            state.spec_pal_last_at=os.time()
        end
        if h and p then
            local dx,dy,dz=p.x-h.x,p.y-h.y,p.z-h.z
            local horizontal=math.sqrt(dx*dx+dy*dy)/100
            local vertical=math.abs(dz)/100
            local full=math.sqrt(dx*dx+dy*dy+dz*dz)/100
            local focal='unknown'
            local focus_ok,position=pcall(function()return state.pc:GetFocalLocation()end)
            if focus_ok and position and num_in_range(position.X,1e8) and num_in_range(position.Y,1e8) and num_in_range(position.Z,1e8) then
                local fdx,fdy,fdz=position.X-p.x,position.Y-p.y,position.Z-p.z
                focal=string.format('%.1f',math.sqrt(fdx*fdx+fdy*fdy+fdz*fdz)/100)
            end
            log(string.format('POSSESSION_NET_3D: kind=%s; human_to_target_horizontal_m=%.1f; vertical_m=%.1f; total_m=%.1f; controller_focal_to_target_m=%s; server_actor_forced_relevant=true; xbox_world_cells_UNVERIFIED=true',
                tostring(state.target_kind),horizontal,vertical,full,focal))
            if full>=120 and not state.stream_warning_120 then
                state.stream_warning_120=true
                log('XBOX_STREAMING_DISTANCE_WARNING: distance>=120m from original human; actor_relevancy_does_NOT_stream_world; optional SAFEON on next trial returns preventively at 170m; no_auto_return_in_current_mode='..tostring(not state.stream_safe))
            end
            if full>=160 and not state.stream_warning_160 then
                state.stream_warning_160=true
                log('XBOX_STREAMING_RISK_HIGH: distance>=160m; possible Xbox freeze; use triple jump or TXT RETURN early; this is not a native crash report')
            end
        end
    end
    local ack_ok,ack=pcall(function() return state.pc.AcknowledgedPawn end)
    if ack_ok and actor_key(ack)==state.pal_key and not state.client_ack_seen then
        state.client_ack_seen=true
        log('PAL_CONTROL_CLIENT_ACK: server_acknowledged_pawn_is_original_pal=true; does_NOT_prove_Xbox_animation_or_streaming')
    elseif not state.client_ack_seen and not state.ack_warned and os.time()-state.direct_started>=10 then
        state.ack_warned=true
        log('PAL_CONTROL_CLIENT_ACK_PENDING: delivery_unverified; no_false_success=true; manual_RETURN_available')
    end
end
function pal_control.tick()
    if pal_control.monitor_busy or not trial or not trial.direct_control then return end
    if type(ExecuteInGameThread)~='function' then return end
    local state=trial
    pal_control.monitor_busy=true
    local queued=pcall(function() ExecuteInGameThread(function()
        local ok=pcall(function() if trial==state then pal_control.check(state) end end)
        pal_control.monitor_busy=false
        pcall(function() pal_control.mobile_update_state(false) end)
        if not ok then log('PAL_CONTROL_MONITOR_ERROR: no_native_mutation_attempted') end
    end) end)
    if not queued then pal_control.monitor_busy=false end
end
function pal_control.toggle(enabled)
    local pc=owner_and_count()
    if not pc then log('PAL_MODE_BLOCKED: owner_admin_required');return end
    LEGACY_WILD_TRIAL_ENABLED=enabled
    log('PAL_MODE_'..(enabled and 'ENABLED' or 'DISABLED')..': applies_to_new_trials_only=true; current_possession_not_interrupted=true')
end
function pal_control.logout(_,exiting)
    if not trial or not trial.direct_control or not exiting then return end
    local ok,pc=pcall(function() return exiting:get() end)
    local state=trial
    if not ok or actor_key(pc)~=state.pc_key then return end
    -- Logout prehook already runs in the game thread, before controller teardown.
    local worked,result=pcall(function() return restore_trial('owner_logout_pre') end)
    if worked then log(result) else log('PAL_CONTROL_LOGOUT_RECOVERY_ERROR') end
    if trial==state then
        state.offline=true
        log('PAL_CONTROL_LOGOUT_PENDING: persistent_journal_retained; no_new_controller_reused=true')
    end
end

function pal_control.return_ai(state)
    if state.offline or not valid(state.ai) or not valid(state.pal) or
       actor_key(state.ai)~=state.ai_key or actor_key(state.pal)~=state.pal_key then
        ai_recovery_uncertain=true
        return false
    end
    if not wild_ai_controls_tracked_pal(state) then
        if state.ai_restore_attempted then return false end
        local readable,current_ai_pawn=pcall(function()return state.ai:K2_GetPawn()end)
        if not readable or (valid(current_ai_pawn) and actor_key(current_ai_pawn)~=state.pal_key) then
            ai_recovery_uncertain=true
            return false
        end
        state.ai_restore_attempted=true
        if not pcall(function() state.ai:Possess(state.pal) end) or
           not wild_ai_controls_tracked_pal(state) then
            ai_recovery_uncertain=true
            return false
        end
    end
    state.ai_returned=true
    schedule_ai_postcheck(state)
    return true
end

-- v1.11.3: desbloqueio PARA RETESTES, nao e um bypass de identidade.
-- Chamado somente no game thread: exige dono unico, admin, pawn humano vivo,
-- classe BP_Player, autoridade nativa e identificador do pawn legivel.
-- Se ainda esta no Pal, faz UMA tentativa de RETURN seguro primeiro.
-- Quando um retorno incompleto deixa um registro Lua pendente, guarda o
-- registro para diagnostico e permite nova tentativa sem deletar personagens.
local retry_retired_sessions={}
auto_retrial_prepare=function(reason)
    local pc,_,why=verified_owner_online(true)
    if not pc then return false,'OWNER_NOT_VERIFIED: '..tostring(why) end
    local pc_key=actor_key(pc)
    if not pc_key then return false,'OWNER_CONTROLLER_NATIVE_ID_UNREADABLE' end
    local got,pawn=pcall(function()return pc:K2_GetPawn()end)
    if not got then return false,'OWNER_PAWN_READ_FAILED' end
    -- O unico retorno automatico admitido quando o jogador ainda esta no Pal:
    -- invocar o fluxo de retorno existente, com todas as verificacoes nativas.
    if trial and (not pawn_matches_human(pawn,trial.human_class)) then
        log('RETRY_RETURN_FIRST: previous trial still active; attempting guarded native return once')
        local result=restore_trial('auto_retrial_before_new_trial')
        log('RETRY_RETURN_RESULT: '..tostring(result))
        got,pawn=pcall(function()return pc:K2_GetPawn()end)
        if not got then return false,'OWNER_PAWN_READ_FAILED_AFTER_RETURN' end
    end
    if not valid(pawn) or pawn:HasAuthority()~=true then
        return false,'OWNER_MUST_CONTROL_AUTHORITATIVE_HUMAN; cannot force another pawn'
    end
    local cls=pawn_class_name(pawn)
    local pawn_key=actor_key(pawn)
    if not cls or not cls:match('^BP_Player_[%w_]+_C$') or not pawn_key then
        return false,'OWNER_MUST_CONTROL_VERIFIED_HUMAN; no arbitrary pawn possession'
    end
    local alive_ok,alive=pcall(function()
        local param=pawn.CharacterParameterComponent
        return valid(param) and param:IsDead()==false
    end)
    if not alive_ok or not alive then
        return false,'OWNER_HUMAN_DEAD_OR_UNREADABLE; cannot guarantee later return'
    end
    local ctl_ok,human_controller=pcall(function()return pawn.Controller end)
    if not ctl_ok or (valid(human_controller) and actor_key(human_controller)~=pc_key) then
        return false,'HUMAN_CURRENTLY_CONTROLLED_BY_ANOTHER_CONTROLLER'
    end
    if trial and trial.pc_key==pc_key and trial.human_key==pawn_key then
        -- Tentar finalizar protecao temporaria/IA do alvo anterior antes de
        -- arquivar uma sessao incompleta: nao deixar flags alterados a toa.
        local result=restore_trial('auto_retrial_human_rollback')
        log('RETRY_HUMAN_ROLLBACK: '..tostring(result))
    end
    if trial then
        local stale=trial
        -- Apos confirmar que o jogo JA controla humano, nunca refazer Possess
        -- num humano antigo, nem destruir o avatar antigo. Para a proxima
        -- tentativa, isolar metadados anteriores e registrar possiveis pendencias.
        if valid(stale.pal) and stale.pal_key and stale.ai_key then
            ai_action_quarantine[stale.pal_key]=stale.ai_key
        end
        stale.offline=true
        track_old_human_if_distinct(stale,pawn)
        retry_retired_sessions[#retry_retired_sessions+1]=stale
        if #retry_retired_sessions>6 then table.remove(retry_retired_sessions,1) end
        log('RETRY_OLD_TRIAL_RETIRED: verified_owner_human_now=true; prior_Pal_AI_or_capture_flags_may_need_review=true; no_native_delete=true; no_old_controller_reuse=true; previous_state_kept_for_diagnostics=true')
        trial=nil
    end
    if recovery_lock then
        if recovery_class and recovery_class~=cls then
            log('RETRY_RECOVERY_CLASS_CHANGED: owner_Guid_admin_human_current_verified=true; old_saved_class_mismatch=true; no_old_actor_mutation=true')
        end
        if not recovery_journal_write(false) then
            return false,'PERSISTENT_RECOVERY_JOURNAL_UNWRITABLE; native_possession_requires_backup_marker'
        end
        recovery_lock=false;recovery_class=nil
        log('RETRY_RECOVERY_AUTO_CLEARED: current owner human verified; no manual !cvg confirm needed; Xbox movement still needs confirmation')
    end
    if ghost then
        log('RETRY_GHOST_ADVISORY_ONLY: old human may still exist; no deletion, no player edits, new trial permitted with verified owner human')
    end
    if ai_postcheck_pending or ai_recovery_uncertain then
        log('RETRY_AI_ADVISORY_ONLY: old actor AI postcheck/uncertainty does not globally block new trials; visually verify old Pal')
    end
    return true,'OWNER_HUMAN_READY'
end

-- v1.11.7: diagnostico do proprio Pal (nao apenas AIActionComponent do Wild AI).
-- NENHUM SetSkill/InitObject/PlayAction/StartAI/alteracao de slot, dano ou cooldown.
-- Captura LEITURA dos golpes equipados no parametro individual e da acao do actor.
local function cvg_skill_array_count(array)
    if array==nil then return 'unavailable' end
    local ok,n=pcall(function()return #array end)
    if ok and type(n)=='number' and n>=0 and n<=1024 then return tostring(n) end
    for _,name in ipairs({'GetArrayNum','Num','Length'}) do
        local worked,value=pcall(function()return array[name](array) end)
        if worked and type(value)=='number' and value>=0 and value<=1024 then return tostring(value) end
    end
    return 'unreadable'
end
local function cvg_actor_skill_probe(pal,ai)
    if not valid(pal) then return 'pal_unavailable' end
    local equipped='unavailable'
    local individual_exists=false
    local ok,param=pcall(function()return pal.CharacterParameterComponent end)
    if ok and valid(param) then
        local ind_ok,ind=pcall(function()return param:GetIndividualParameter()end)
        if not ind_ok or not valid(ind) then
            ind_ok,ind=pcall(function()return param.IndividualParameter end)
        end
        if ind_ok and valid(ind) then
            individual_exists=true
            local e_ok,e=pcall(function()return ind:GetEquipWaza() end)
            if e_ok and e~=nil then equipped=cvg_skill_array_count(e) end
        end
    end
    local component_exists=false
    local action='unavailable'
    local action_empty='unavailable'
    local action_type='unavailable'
    local okc,component=pcall(function()return pal.ActionComponent end)
    if okc and valid(component) then
        component_exists=true
        local got,current=pcall(function()return component:GetCurrentAction()end)
        if got then action=valid(current) and (pawn_class_name(current) or 'action_present') or 'none' end
        local empt_ok,empty=pcall(function()return component:ActionIsEmpty()end)
        if empt_ok then action_empty=tostring(empty) end
        local t_ok,t=pcall(function()return component:GetCurrentActionType(false)end)
        if t_ok then action_type=tostring(t):sub(1,64) end
    end
    local ai_slot_exists=false
    local ai_slots={}
    if valid(ai) then
        local slot_ok,slot=pcall(function()return ai.SkillSlot end)
        if slot_ok and valid(slot) then
            ai_slot_exists=true
            for i=0,3 do
                local status='?'
                local a,b=pcall(function()return slot:IsValidSkill(i)end)
                if a then status=tostring(b) end
                local wid='unavailable'
                local w_ok,w=pcall(function()return slot:GetWazaType(i)end)
                if w_ok and w~=nil then wid=tostring(w):sub(1,38) end
                ai_slots[#ai_slots+1]=tostring(i)..'='..status..'/'..wid
            end
        end
    end
    return 'individual_parameter='..tostring(individual_exists)
        ..'; equip_waza_count='..equipped
        ..'; own_pal_action_component='..tostring(component_exists)
        ..'; own_pal_action='..action
        ..'; own_pal_action_empty='..action_empty
        ..'; own_pal_action_type='..action_type
        ..'; original_ai_skill_slot='..tostring(ai_slot_exists)
        ..'; ai_valid_waza='..table.concat(ai_slots,',')
        ..'; read_only=true'
end

local function start_trial(preview,npc_mode,camera_mode,boss_only)
    boss_only=boss_only==true and not npc_mode
    if not preview and not CVG_NATIVE_POSSESSION_ENABLED then
        log('CVG_PROTECTED_TRIAL_BLOCKED: native Possess disabled in protected profile; CHECK still available; no actor modified')
        return
    end
    if not LEGACY_WILD_TRIAL_ENABLED then
        log('BOSSMODE_LEGACY_WILD_BLOCKED: posse de Pal selvagem desativada nesta versao; nao faz spawn; nao altera atores')
        return
    end
    local tag=boss_only and (preview and 'CAMBOSS_CHECK' or 'CAMBOSS_TRIAL') or (camera_mode and (npc_mode and (preview and 'CAMNPC_CHECK' or 'CAMNPC_TRIAL') or (preview and 'CAMPAL_CHECK' or 'CAMPAL_TRIAL')) or (npc_mode and (preview and 'NPC_CHECK' or 'NPC_TRIAL') or (preview and 'CHECK' or 'TRIAL')))
    if pal_control.handoff_pending then log(tag..'_HANDOFF_PENDING: previous spectator transition not finished; no second Possess');return end
    if npc_mode then
        log('NPC_HUMANO_MODE: mode='..(preview and 'PREFLIGHT_ONLY' or 'POSSESSION')..'; PalNPC=true; IsPal=false; PalMonsterCharacter=false; real_players_excluded=true; original_NPC_AI_preserved=true; selection=nearest_unique; chat_unavailable_during_Xbox_possession=true')
    end
    -- Reinicio/reconexao/AI/ghost antigos nao sao travas manuais: a nova
    -- tentativa recupera automaticamente quando O DONO ja esta no humano.
    if not preview and (trial or recovery_lock or ghost or ai_postcheck_pending or ai_recovery_uncertain) then
        local ready,why=auto_retrial_prepare('start_trial')
        if not ready then
            log(tag..'_RETRY_NEEDS_HUMAN: '..tostring(why)..'; no unsafe Possess')
            return
        end
    end
    if not preview and (type(ExecuteWithDelay)~='function' or type(ExecuteInGameThread)~='function') then
        log('TRIAL_UNAVAILABLE: game thread/recovery API missing; no native possession')
        return
    end
    if trial then
        log(tag..'_RETRY_NEEDS_HUMAN: original session not safely returned; no other pawn touched')
        return
    end
    if type(FindAllOf)~='function' or type(FindObjects)~='function' then
        log(tag..'_BLOCKED: UE4SS FindObjects API unavailable; not_consumed=true');return
    end
    if EObjectFlags==nil or EObjectFlags.RF_NoFlags==nil or EObjectFlags.RF_ClassDefaultObject==nil then
        log(tag..'_BLOCKED: UE4SS object flags unavailable; not_consumed=true');return
    end
    log(tag..'_STAGE_1: owner GUID/admin authorization; other players permitted')
    local ok,result=pcall(function()
        local pc,players,issue=owner_and_count()
        if not pc then return tag..'_BLOCKED: '..issue..'; not_consumed=true' end
        local camera_context=nil
        local human=nil
        if camera_mode then
            local cam_error
            camera_context,cam_error=camera_possession_origin(pc)
            if not camera_context then
                return tag..'_BLOCKED: '..tostring(cam_error)..'; no native call'
            end
            human=camera_context.human
        else
            human=pc:K2_GetPawn()
        end
        if not valid(human) or human:HasAuthority()~=true then
            return tag..'_BLOCKED: original human pawn invalid; not_consumed=true'
        end
        local cls=pawn_class_name(human)
        if not cls or not cls:match('^BP_Player_[%w_]+_C$') then
            return tag..'_BLOCKED: original_human_class_not_verified; no_native_call'
        end
        if not preview and (not death_hook_installed or not capture_hook_installed) then
            return 'TRIAL_BLOCKED: death_or_capture_event_hook_not_ready; no_native_call'
        end
        local p=camera_mode and camera_context.pos or human:K2_GetActorLocation()
        local ok_r,r=pcall(function() return pc:GetControlRotation() end)
        if p==nil then return tag..'_BLOCKED: camera/owner geometry unavailable; not_consumed=true' end
        local yaw=ok_r and r and normalize_angle_precise(r.Yaw) or nil
        local pitch=ok_r and r and normalize_angle_precise(r.Pitch) or nil
        local verified_camera_aim=camera_mode and camera_context.aim_verified==true
        if verified_camera_aim then
            yaw,pitch=camera_context.yaw,camera_context.pitch
        elseif camera_mode and (yaw==nil or pitch==nil) then
            yaw,pitch=0,0 -- APENAS diagnostico: sem RPC de rotacao, nao escolher pela mira.
        end
        local radius_cm=camera_mode and (verified_camera_aim and CAMERA_AIM_RADIUS_CM or CAMERA_TRIAL_RADIUS_CM) or TRIAL_MAX_DISTANCE_CM
        local x,y,z=camera_mode and p.x or p.X,camera_mode and p.y or p.Y,camera_mode and p.z or p.Z
        if yaw==nil or pitch==nil or not(num_in_range(x,1e8) and num_in_range(y,1e8) and num_in_range(z,1e8)) then
            return tag..'_BLOCKED: invalid owner geometry; not_consumed=true'
        end
        local yr,pr=math.rad(yaw),math.rad(pitch)
        local fx,fy,fz=math.cos(pr)*math.cos(yr),math.cos(pr)*math.sin(yr),math.sin(pr)
        log(tag..'_STAGE_2: bounded target scan max 1024; origin='..(camera_mode and 'verified_server_spectator_camera' or 'human_pawn')..'; max_distance_m='..string.format('%.0f',radius_cm/100)..'; selection='..(verified_camera_aim and 'verified_rpc_camera_cone' or 'nearest_unique_fallback')..'; no Xbox reticle access')
        local found=FindObjects(TRIAL_MAX_OBJECTS,'PalCharacter',nil,
            EObjectFlags.RF_NoFlags,EObjectFlags.RF_ClassDefaultObject,false) or {}
        if #found>=TRIAL_MAX_OBJECTS then
            return tag..'_BLOCKED: sample reached object cap; cannot prove unique target; not_consumed=true'
        end
        local matches=0
        local chosen,chosen_ai,chosen_class,chosen_distance=nil,nil,nil,nil
        local wild_count,in_range_count,cone_count=0,0,0
        local closest_wild=nil
        local smallest_angle_in_range=nil
        local best_yaw_error_in_range=nil
        local best_pitch_error_in_range=nil
        local best_candidate_angle=nil
        local candidates={}
        local i=0
        for _,actor in ipairs(found) do
            i=i+1
            if i>TRIAL_MAX_OBJECTS then break end
            local verified,entry=pcall(function()
                if not valid(actor) or actor:HasAuthority()~=true then return nil end
                local cls=actor:GetClass()
                if not valid(cls) then return nil end
                local cn=cls:GetFName():ToString()
                if type(cn)~='string' then return nil end
                local target_kind=pal_control.target_kind(actor)
                if target_kind~=(npc_mode and 'NPC' or 'PAL') then return nil end
                local ai=actor.Controller
                if not valid(ai) or ai:HasAuthority()~=true then return nil end
                local cl=ai:GetClass()
                if not valid(cl) then return nil end
                local ai_name=cl:GetFName():ToString()
                if type(ai_name)~='string' then return nil end
                local ai_class=StaticFindObject('/Script/Pal.PalAIController')
                if not valid(ai_class) or not ai:IsA(ai_class) or ai_name:find('Player',1,true) or
                   ai_name:find('BaseCamp',1,true) or ai_name:find('Otomo',1,true) then return nil end
                local eligible,is_boss=cvg_pal_camera_candidate(cn,ai_name,npc_mode,boss_only)
                if not eligible then return nil end
                local a=actor:K2_GetActorLocation()
                if a==nil then return nil end
                local ax,ay,az=a.X,a.Y,a.Z
                if not(num_in_range(ax,1e8) and num_in_range(ay,1e8) and num_in_range(az,1e8)) then return nil end
                local dx,dy,dz=ax-x,ay-y,az-z
                local distance=math.sqrt(dx*dx+dy*dy+dz*dz)
                if not num_in_range(distance,2e8) or distance<=1 then return nil end
                local dot=(dx*fx+dy*fy+dz*fz)/distance
                if not num_in_range(dot,1.0001) then return nil end
                dot=math.max(-1, math.min(1,dot))
                local angle=math.deg(math.acos(dot))
                local planar=math.sqrt(dx*dx+dy*dy)
                if planar<=1 then return nil end
                local yawdot=(dx*math.cos(yr)+dy*math.sin(yr))/planar
                if not num_in_range(yawdot,1.0001) then return nil end
                yawdot=math.max(-1,math.min(1,yawdot))
                local yaw_error=math.deg(math.acos(yawdot))
                local target_pitch=math.deg(math.atan(dz/planar))
                local pitch_error=math.abs((target_pitch-pitch+180)%360-180)
                if not num_in_range(yaw_error,180.001) or not num_in_range(pitch_error,180.001) then return nil end
                return {pal=actor,ai=ai,distance=distance,angle=angle,
                    selected_pos={x=ax,y=ay,z=az},
                    class_name=cn:gsub('[^%w_]',''):sub(1,36),
                    is_boss=is_boss,ai_class=ai_name:gsub('[^%w_]',''):sub(1,40),
                    yaw_error=yaw_error,pitch_error=pitch_error}
            end)
            if verified and entry then
                wild_count=wild_count+1
                if closest_wild==nil or entry.distance<closest_wild then closest_wild=entry.distance end
                if entry.distance>=TRIAL_MIN_DISTANCE_CM and
                   entry.distance<=radius_cm then
                    in_range_count=in_range_count+1
                    candidates[#candidates+1]=entry
                    if smallest_angle_in_range==nil or entry.angle<smallest_angle_in_range then
                        smallest_angle_in_range=entry.angle
                    end
                    if best_candidate_angle==nil or entry.angle<best_candidate_angle then
                        best_candidate_angle=entry.angle
                        best_yaw_error_in_range=entry.yaw_error
                        best_pitch_error_in_range=entry.pitch_error
                    end
                    if entry.angle<=TRIAL_CONE_DEGREES then cone_count=cone_count+1 end
                end
            end
        end
        local m=closest_wild and string.format('%.1f',closest_wild/100) or 'none'
        local deg=smallest_angle_in_range and string.format('%.1f',smallest_angle_in_range) or 'none'
        local yawdeg=best_yaw_error_in_range and string.format('%.2f',best_yaw_error_in_range) or 'none'
        local pitchdeg=best_pitch_error_in_range and string.format('%.2f',best_pitch_error_in_range) or 'none'
        log(string.format('%s_TARGET_STATS: sampled=%d; wild_nonboss=%d; in_mode_range=%d; within_15deg=%d; closest_wild_m=%s; best_angle_inrange_deg=%s; best_yaw_error_deg=%s; best_pitch_error_deg=%s; selection=nearest_with_separation; camera_mode=%s; no_reticle_access=true; partial_sample=true; no_raytrace=true',
            tag,i,wild_count,in_range_count,cone_count,m,deg,yawdeg,pitchdeg,tostring(camera_mode==true)))
        if boss_only then log('CAMBOSS_FILTER_ACTIVE: Boss_Pal_only=true; Wild_or_Boss_AI=true; Raid_Tower_Trainer_excluded=true; no_global_flags_modified=true') end
        if camera_mode then log(tag..'_AIM_SOURCE: native_rpc_rotation='..tostring(verified_camera_aim)..'; fallback_nearest='..tostring(not verified_camera_aim)..'; actor_origin_not_hitbox=true; safe_no_raytrace=true') end
        if in_range_count<1 then
            return tag..'_BLOCKED: expected eligible '..(npc_mode and 'NPC' or 'Pal')..' within '..string.format('%.0fm',radius_cm/100)..' of '..(camera_mode and 'SERVER camera' or 'owner')..'; found=0; no actors modified; not_consumed=true'
        end
        -- RPC do espectador e recebido do Xbox no mesmo componente autenticado;
        -- yaw/pitch sao direcao APROXIMADA, nao o cursor/pixel da mira. Validar
        -- cone 3D e usar angulo anterior a proximidade. Empate = BLOQUEIO.
        local nearest,second=nil,nil
        if verified_camera_aim then
            local aimed={}
            for _,candidate in ipairs(candidates) do
                if candidate.angle<=CAMERA_AIM_MAX_3D_DEG and
                   candidate.yaw_error<=CAMERA_AIM_MAX_YAW_DEG and
                   candidate.pitch_error<=CAMERA_AIM_MAX_PITCH_DEG then
                    -- Penalizar discretamente distancia; privilegia direcao central.
                    candidate.aim_score=candidate.yaw_error+0.40*candidate.pitch_error+0.22*candidate.distance/100
                    aimed[#aimed+1]=candidate
                end
            end
            table.sort(aimed,function(a,b)
                if a.aim_score~=b.aim_score then return a.aim_score<b.aim_score end
                return a.distance<b.distance
            end)
            nearest,second=aimed[1],aimed[2]
            if not nearest then
                return tag..'_BLOCKED: no Pal/NPC in verified RPC camera cone (yaw<=30deg/pitch<=55deg); move camera toward target; no native call'
            end
            if second and second.aim_score-nearest.aim_score<CAMERA_AIM_MIN_SCORE_GAP then
                log(string.format('%s_AIM_AMBIGUOUS: top_score=%.1f; second_score=%.1f; no_actor_modified=true',tag,nearest.aim_score,second.aim_score))
                return tag..'_BLOCKED: mira aponta para dois alvos proximos; aproxime camera ou isole o Pal; no native call'
            end
            log(string.format('%s_AIM_SELECTED: angle_deg=%.1f; yaw_error=%.1f; pitch_error=%.1f; distance_m=%.1f; candidate_count=%d; estimated_camera_cone=true; NO_XBOX_RETICLE_RAYTRACE',
                tag,nearest.angle,nearest.yaw_error,nearest.pitch_error,nearest.distance/100,#aimed))
        else
            -- Fallback inalterado: 8m e alvo MAIS PROXIMO, com ampla separacao.
            -- Nao confiar em ControlRotation quando RPC Xbox nao forneceu rotacao.
            table.sort(candidates,function(a,b) return a.distance<b.distance end)
            nearest,second=candidates[1],candidates[2]
            local required_second_cm=math.max(nearest.distance+(camera_mode and 200 or 300),nearest.distance*1.5)
            if second and second.distance<=required_second_cm then
                log(string.format('%s_AMBIGUOUS: closest_m=%.1f; second_m=%.1f; fallback_distance_only=true; no_actor_modified=true',
                    tag,nearest.distance/100,second.distance/100))
                return tag..'_BLOCKED: alvo ambiguo; found='..in_range_count..'; no actors modified; not_consumed=true'
            end
        end
        chosen,chosen_ai,chosen_class,chosen_distance=nearest.pal,nearest.ai,nearest.class_name,nearest.distance
        if nearest.is_boss then
            log(tag..'_BOSSPAL_SELECTED: class='..chosen_class..'; ai_class='..nearest.ai_class..'; camera='..tostring(camera_mode)..'; target_original=true; xbox_reticle_not_verified=true')
        end
        -- Nao repetir a posse no MESMO Pal cuja acao de IA nao foi observada
        -- apos o retorno. Isto e um bloqueio POR ATOR, nao global/multiplayer.
        -- Quarantine applies to BOTH wild Pals and non-Pal NPCs.
        -- Do not repossess an actor whose AI action did not recover.
        local candidate_key=actor_key(chosen)
        local prior_ai=candidate_key and ai_action_quarantine[candidate_key] or nil
        if prior_ai then
            local present,empty,action=native_pal_action_snapshot(chosen_ai)
            local active=native_pal_ai_active(chosen_ai)
            if actor_key(chosen_ai)==prior_ai and present and action==true and empty~=true and active==true then
                ai_action_quarantine[candidate_key]=nil
                log('AI_QUARANTINE_CLEARED: exact tracked target recovered action; no actor modified')
            else
                -- Usuario pediu RETESTE sem quarentena como trava de entrada.
                -- Ainda exigimos que o ator esteja vivo, Wild e com AI nativa
                -- no teste remains_wild abaixo. Nao mudamos sua IA aqui.
                log('RETRY_SAME_PAL_AI_WARNING: previous actor AI unverified; permitted only while exact current Wild AI remains valid; no automatic AI mutation')
            end
        end
        local remains_wild,wild_ok=pcall(function()
            if not valid(chosen) or not valid(chosen_ai) then return false end
            local present_ai=chosen.Controller
            if not valid(present_ai) or present_ai:HasAuthority()~=true then return false end
            local present_class=present_ai:GetClass()
            if not valid(present_class) then return false end
            local name=present_class:GetFName():ToString()
            local native_class=pawn_class_name(chosen)
            local eligible,is_boss=cvg_pal_camera_candidate(native_class,name,npc_mode,boss_only)
            return type(name)=='string' and actor_key(present_ai)==actor_key(chosen_ai) and
                pal_control.target_kind(chosen)==(npc_mode and 'NPC' or 'PAL') and
                eligible and is_boss==nearest.is_boss
        end)
        if not remains_wild or not wild_ok then
            return tag..'_BLOCKED: candidate became invalid or native Pal/Boss AI changed; no actors modified; not_consumed=true'
        end
        local function cvg_commit_verified_possession()
            if camera_mode and camera_context and camera_context.cvg_native and not preview then
                -- All checks are on the game thread; no new world scan.
                -- v13: mesmos prechecks e mesmo bloqueio fail-closed da v12.
                -- Apenas separar a causa; NAO relaxar espectador, dono ou IA.
                local checked,gate=pcall(function()
                    if not valid(pc) then return 'PC_INVALID' end
                    if not valid(human) then return 'HUMAN_INVALID' end
                    if not valid(chosen) then return 'PAL_INVALID' end
                    if not valid(chosen_ai) then return 'AI_INVALID' end
                    if pc.bAdmin~=true then return 'ADMIN_FLAG_FALSE' end
                    if pc:HasAuthority()~=true then return 'PC_NONAUTHORITY' end
                    local current=pc:K2_GetPawn()
                    if actor_key(current)~=camera_context.human_key then return 'PAWN_NOT_ORIGINAL_HUMAN' end
                    if actor_key(human)~=camera_context.human_key then return 'SAVED_HUMAN_CHANGED' end
                    if pawn_class_name(current)~=pawn_class_name(human) then return 'HUMAN_CLASS_CHANGED' end
                    if pc:IsSpectating()~=false then return 'SPECTATE_FLAG_NOT_FALSE' end
                    local current_ai=chosen.Controller
                    if actor_key(current_ai)~=actor_key(chosen_ai) then return 'PAL_AI_CONTROLLER_CHANGED' end
                    if chosen:HasAuthority()~=true then return 'PAL_NONAUTHORITY' end
                    if chosen_ai:HasAuthority()~=true then return 'AI_NONAUTHORITY' end
                    return 'OK'
                end)
                if not checked or gate~='OK' then
                    return 'CVG_HANDOFF_ABORTED: gate='..tostring(checked and gate or 'PRECHECK_LUA_EXCEPTION')..'; no capture write, no journal, no Possess; inspect_Xbox=true'
                end
                log('CVG_HANDOFF_REVALIDATED: exact human and original Wild AI; spectator state ended; proceeding to snapshot')
            end
        local focus_baseline,focus_reason=pal_control.snapshot(pc,human,chosen)
        if not focus_baseline then
            return tag..'_BLOCKED: '..focus_reason..'; no_native_call'
        end
        if preview then
            return string.format('%s_READY: nearest eligible %s class=%s at %.1fm from %s (next clear or absent); not reticle-verified; no actor modified; not_consumed=true', tag, npc_mode and 'NPC' or (nearest.is_boss and 'Boss Pal' or 'Pal'),
                chosen_class,chosen_distance/100,camera_mode and 'SERVER_SPECTATOR_CAMERA' or 'OWNER_HUMAN')
        end
        log(string.format((npc_mode and 'NPC_TRIAL_SELECTED' or 'TRIAL_SELECTED')..': pal_class=%s; distance_m=%.1f; selection=%s; second_m=%s; xbox_exact_reticle_unverified=true',
            chosen_class,chosen_distance/100,verified_camera_aim and 'native_rpc_camera_cone' or 'nearest_distance_fallback',second and string.format('%.1f',second.distance/100) or 'none'))
        if camera_mode and not (camera_context and camera_context.cvg_native) then
            local latest,latest_reason=camera_possession_origin(pc)
            if not latest or latest.camera_key~=camera_context.camera_key or
               (cam_delta(latest.pos,camera_context.pos) or math.huge)>250 then
                return tag..'_BLOCKED: camera moved/changed during scan or '..tostring(latest_reason)..'; no native call'
            end
        end
        -- Gravacao ANTES do native: apos crash/reboot, bloquear novas possessoes.
        -- Nenhum dado pessoal no arquivo; so nome da classe do humano.
        local human_class=pawn_class_name(human)
        if type(human_class)~='string' or not human_class:match('^[%w_]+$') then
            return 'RECOVERY_JOURNAL_BLOCKED: cannot validate human actor class; no actors modified'
        end
        if not actor_key(chosen) or not actor_key(pc) then
            return 'TRIAL_BLOCKED: cannot track native Pal/controller identity; no actors modified'
        end
        local pre_brain=tracked_brain(chosen_ai)
        local pre_brain_key=actor_key(pre_brain)
        local pre_brain_running,pre_brain_paused=brain_read(pre_brain)
        local pal_native_before=native_pal_ai_active(chosen_ai)
        local pal_ai_component_before,pal_ai_action_empty_before,pal_ai_action_present_before=native_pal_action_snapshot(chosen_ai)
        local ai_component_before=get_native_ai_component(chosen_ai)
        local ai_comp_key_before=actor_key(ai_component_before)
        local ai_roots_before=action_roots_snapshot(ai_component_before)
        if not npc_mode then
            log('SKILL_AUTO_PROBE_SKIPPED_BEFORE_POSSESS: no_GetEquipWaza_no_ActionComponent_skill_reads; manual_skill_commands_unchanged=true')
        end
        log('AI_BASELINE: original_wild_controller=true; native_active='..tostring(pal_native_before)..
            '; action_component='..tostring(pal_ai_component_before)..'; action_empty='..tostring(pal_ai_action_empty_before)..
            '; action_present='..tostring(pal_ai_action_present_before)..'; original_roots='..root_count(ai_roots_before)..'; brain_available='..tostring(pre_brain_key~=nil)..
            '; brain_running='..tostring(pre_brain_running)..'; brain_paused='..tostring(pre_brain_paused)..'; read_only=true')
        local capture_baseline=nil
        if not npc_mode then
            local cap_reason
            capture_baseline,cap_reason=capture_guard.snapshot(chosen)
            if not capture_baseline then
                return 'TRIAL_BLOCKED_CAPTURE_GUARD: '..tostring(cap_reason)..'; no_native_possess; no_pal_modified'
            end
            log('CAPTURE_GUARD_BASELINE: exact_wild_pal=true; individual='..tostring(capture_baseline.unc)..
                '; force='..tostring(capture_baseline.force)..'; static='..tostring(capture_baseline.sunc)..'; read_only=true')
        end
        local range_original=nil -- direct mode uses exact snapshots, no finite distance boost.
        if not recovery_journal_write(true,human_class) then
            return 'RECOVERY_JOURNAL_BLOCKED: persistent recovery journal unavailable; no actors modified'
        end
        recovery_lock=true;recovery_class=human_class
        trial={pc=pc,pc_key=actor_key(pc),human=human,human_class=human_class,pal=chosen,pal_class=chosen_class,
            ai=chosen_ai,ai_key=actor_key(chosen_ai),human_key=actor_key(human),
            brain_key=pre_brain_key,brain_was_running=pre_brain_running,brain_was_paused=pre_brain_paused,
            pal_ai_was_active=pal_native_before,pal_ai_action_empty=pal_ai_action_empty_before,
            pal_ai_action_present=pal_ai_action_present_before,ai_component_key=ai_comp_key_before,
            ai_roots=ai_roots_before,action_repair_attempted=false,
            native_reactivate_attempted=false,default_action_attempted=false,ai_brain_restart_attempted=false,restoring=false,
            focus_baseline=focus_baseline,focus_dirty=false,direct_control=false,target_kind=npc_mode and 'NPC' or 'PAL',
            pal_key=actor_key(chosen),jump_times={},jump_exit_pending=false,controlled=false,
            pal_lost=false,emergency_pending=false,emergency_attempted=false,resync_attempted=false,
            offline=false,restore_attempts=0,reconnect_attempts=0,
            range_original=range_original,range_applied=false,capture_guard=capture_baseline,
            stream_safe=stream_safe_enabled,stream_safe_return_requested=false}
        if camera_mode then
            -- SNAPSHOT DO /ToggleSpectate NATIVO do jogo, nao do CVGSPEC.
            -- Sempre recuperar o humano original primeiro para limpar journal/IA.
            -- Depois, reativar o espectador nativo e devolver a camera a
            -- ultima posicao observada do Pal quando o servidor expuser um SpectatorPawn.
            trial.camera_entry=true
            trial.camera_source=camera_context.camera_kind
            trial.spec_from_native_game=camera_context.native_reused==true or
                (camera_context.cvg_native~=true and
                 camera_context.camera_kind~='native_server_spectator_rpc')
            trial.spec_entry_pos={x=camera_context.pos.x,y=camera_context.pos.y,z=camera_context.pos.z}
            trial.spec_pal_last_pos=nearest.selected_pos
            trial.spec_pal_last_at=os.time()
            trial.spec_pal_last_source='target_scan_existing'
            trial.focus_baseline.attach=true
            trial.focus_baseline.auto=true
            trial.focus_baseline.streaming=true
            if trial.spec_from_native_game then
                pal_control.spec_pending=nil -- evitar reutilizar estado de outra sessao
            end
            log('CAM_POSSESSION_PREPARED: original_human_verified=true; camera_source='..tostring(camera_context.camera_kind)..'; native_game_spectate_saved='..tostring(trial.spec_from_native_game)..'; return_human_first=true; resume_native_spectate_after_safe=true; no_new_loop=true')
        end
        if not npc_mode then
            local cap_ok,cap_reason=capture_guard.apply(trial)
            if not cap_ok then
                local rollback=restore_trial('capture_guard_arm_failed')
                return 'TRIAL_BLOCKED_CAPTURE_GUARD: '..tostring(cap_reason)..'; '..tostring(rollback)
            end
        end
        log(string.format('TRIAL_STAGE_3: pal_class=%s; distance_m=%.1f; origin=%s; return_mode=MANUAL_TXT_OR_THREE_JUMPS; no_duration_or_distance_return=true; calling native Possess',chosen_class,chosen_distance/100,camera_mode and 'server_spectator_camera' or 'owner_human'))
        local invoked=pcall(function() pc:Possess(chosen) end)
        if invoked then log('CVG_MITIGATION_PC_POSSESS_RETURNED: native_function_returned_to_Lua; not_Xbox_verified=true') end
        if not invoked then
            local msg=restore_trial('possess_lua_error')
            return 'TRIAL_CALL_FAILED: Possess raised Lua error; '..msg
        end
        local checked,current=pcall(function()return pc:K2_GetPawn()end)
        if not checked or not trial or actor_key(current)~=trial.pal_key then
            return 'TRIAL_CALL_FAILED: server_pawn_transfer_unverified; '..restore_trial('possession_unverified')
        end
        trial.controlled=true
        local setup,setup_reason=pal_control.apply(trial)
        if not setup then
            local restored=restore_trial('direct_setup_'..tostring(setup_reason))
            return 'TRIAL_CALL_FAILED: '..tostring(setup_reason)..'; '..restored
        end
        if not npc_mode then
            log('SKILL_AUTO_PROBE_SKIPPED_AFTER_POSSESS: no_GetEquipWaza_no_ActionComponent_skill_reads; Xbox_validation_pending=true')
        end
        log('TRIAL_MANUAL_RETURN: no_duration_timer; no_distance_return; use_RETURN_in_private_TXT; Xbox_controls_unverified')
        if npc_mode then
            return 'NPC_TRIAL_CALLED: original_human_NPC_possessed_on_server; NPC_IsPal_false=true; capture_guard_not_applied_to_NPC=true; same_native_return_and_AI_postcheck; Xbox_test_required; return=3_jumps_or_private_TXT'
        end
        return 'TRIAL_CALLED: original_Wild_Pal_possessed_on_server; client_retry_and_view_RPC_sent; Xbox_test_required'
        end
        -- End native spectate BEFORE snapshot/possession; spectator camera may
        -- otherwise overwrite ClientRetryClientRestart and leave Xbox frozen.
        -- THIS occurs only for real possession; CHECK remains fully read-only.
        if camera_mode and camera_context and camera_context.cvg_native and not preview then
            local last,last_error=camera_possession_origin(pc)
            if not last or last.camera_key~=camera_context.camera_key or
               (cam_delta(last.pos,camera_context.pos) or math.huge)>250 then
                return tag..'_BLOCKED: CVGSPEC RPC changed/stale before exit: '..tostring(last_error)
            end
            log('CVG_HANDOFF_BEFORE_ENDSPECTATE: verified camera selection; no capture writes yet')
            local ended=pcall(function()pc:EndSpectate()end)
            if not ended then
                return tag..'_BLOCKED: native EndSpectate failed; no possession; remain in spectator'
            end
            local pawn_ok,human_current=pcall(function()return pc:K2_GetPawn()end)
            local human_immediate=pawn_ok and actor_key(human_current)==camera_context.human_key and
                pawn_class_name(human_current)==pawn_class_name(human)
            -- EndSpectate pode concluir seu estado no frame seguinte. A falta
            -- de humano IMEDIATO nao autoriza posse; revalidar no agendamento.
            if not human_immediate then
                log('CVG_HANDOFF_TRANSITION_PENDING: immediate_human_pawn_unconfirmed=true; bounded_readonly_checks=3; no_native_Possess_yet=true')
            end
            local human_pos_after=cam_geo(human)
            if not human_pos_after then
                return tag..'_BLOCKED: original human position unreadable after EndSpectate; no possession'
            end
            if (cam_delta(human_pos_after,cam_baseline.pos) or 0)>CAMERA_HUMAN_MAX_DRIFT_CM then
                log('RETRY_HUMAN_POSITION_REBASE: verified original human moved while spectating; positional gate waived without changing pawn identity')
            end
            cam_baseline=nil;cam_previous=nil;cam_sync=nil
            local flag_ok,flag_value=pcall(function()return pc:IsSpectating()end)
            log('CVG_HANDOFF_ENDSPECTATE_IMMEDIATE: human_key_verified='..tostring(human_immediate)..'; spectate_query_ok='..tostring(flag_ok)
                ..'; spectate_flag='..tostring(flag_ok and flag_value or 'ERROR')
                ..'; delayed_recheck_only=true; no_extra_native_end=true')
            log('CVG_HANDOFF_ENDSPECTATE_RETURNED: EndSpectate called once; pending verified human/spectate/AI at later game-thread turn')
            pal_control.handoff_serial=pal_control.handoff_serial+1
            local token=pal_control.handoff_serial
            local pending={token=token,pc_key=actor_key(pc),human_key=camera_context.human_key}
            pal_control.handoff_pending=pending
            -- Leitura no maximo 3 vezes, nos instantes ~1.7/2.6/3.5s.
            -- O proprio commit CONFERE humano exato, spectator=false, IA, owner.
            -- Apenas dois estados transitorios podem ganhar uma nova leitura:
            -- nenhum segundo EndSpectate, nenhuma segunda tentativa de Possess.
            local function schedule_handoff_check(attempt,delay_ms)
                local queued=pcall(function()
                    ExecuteWithDelay(delay_ms,function()
                        local sent=pcall(function()
                            ExecuteInGameThread(function()
                                if pal_control.handoff_pending~=pending or pending.cancelled then
                                    if pal_control.handoff_pending==pending then pal_control.handoff_pending=nil end
                                    log('CVG_HANDOFF_CANCELLED: no native Possess')
                                    return
                                end
                                if trial or recovery_lock then
                                    pal_control.handoff_pending=nil
                                    log('CVG_HANDOFF_ABORTED: other trial/recovery started; no native Possess')
                                    return
                                end
                                if actor_key(pc)~=pending.pc_key or actor_key(human)~=pending.human_key then
                                    pal_control.handoff_pending=nil
                                    log('CVG_HANDOFF_ABORTED: gate=OWNER_OR_HUMAN_IDENTITY_CHANGED; no native Possess')
                                    return
                                end
                                local executed,result=pcall(cvg_commit_verified_possession)
                                if not executed then
                                    pal_control.handoff_pending=nil
                                    log('CVG_HANDOFF_LUA_ERROR: unexpected commit failure; no retry')
                                    if trial then log(restore_trial('handoff_commit_lua_error')) end
                                    return
                                end
                                local transient=type(result)=='string' and
                                    (result:find('gate=PAWN_NOT_ORIGINAL_HUMAN',1,true) or
                                     result:find('gate=SPECTATE_FLAG_NOT_FALSE',1,true))
                                if transient and attempt<3 then
                                    log('CVG_HANDOFF_RECHECK_PENDING: attempt='..attempt..'/3; '..tostring(result)..'; next_in_ms=900; no Possess yet')
                                    if not schedule_handoff_check(attempt+1,900) then
                                        pal_control.handoff_pending=nil
                                        log('CVG_HANDOFF_FAILED: bounded recheck could not be scheduled; no Possess')
                                    end
                                    return
                                end
                                pal_control.handoff_pending=nil
                                if transient then log('CVG_HANDOFF_RECHECK_EXHAUSTED: attempts=3; no native Possess; inspect server spectate state') end
                                log(result)
                            end)
                        end)
                        if not sent then
                            if pal_control.handoff_pending==pending then pal_control.handoff_pending=nil end
                            log('CVG_HANDOFF_FAILED: could not dispatch game-thread recheck; no Possess')
                        end
                    end)
                end)
                return queued
            end
            if not schedule_handoff_check(1,1700) then
                pal_control.handoff_pending=nil
                return 'CVG_HANDOFF_ABORTED: cannot register delayed continuation; no native Possess'
            end
            return 'CVG_HANDOFF_QUEUED: spectator exit called once; up to 3 bounded read-only checks; one native Possess only after exact validation'

        end
        return cvg_commit_verified_possession()

    end)
    if ok then log(result)
    else
        log(tag..'_FAILED: Lua diagnostic error; trying return if active')
        if trial then log(restore_trial('unexpected_lua_error')) end
    end
end
-- v1.8.5: intercepta APENAS evento nativo ACharacter.OnJumped; sem timer,
-- sem varredura de Pals/jogadores por tick. No servidor dedicado nao e
-- comprovado que o salto do Pal possuido dispare esta UFunction.
-- Use Context:get() para validar o objeto do hook; nunca usar tecla ESC do Xbox.
local function on_character_jumped(context)
    local state=trial
    if not state or not jump_hook_installed or not state.controlled or
       state.restoring or state.jump_exit_pending or not state.pal_key then return end
    local ok,pal=pcall(function()
        if context==nil then return nil end
        return context:get()
    end)
    if not ok or not valid(pal) or actor_key(pal)~=state.pal_key then return end
    local now=os.time()
    if type(now)~='number' then return end
    local times=state.jump_times or {}
    local fresh={}
    for _,t in ipairs(times) do
        if now>=t and now-t<=JUMP_WINDOW_SECONDS then fresh[#fresh+1]=t end
    end
    fresh[#fresh+1]=now
    state.jump_times=fresh
    local count=#fresh
    if count>3 then count=3 end
    log('JUMP_'..count..': native OnJumped seen for possessed owner Pal; count='..count..'; window=5s')
    if count<3 then return end
    state.jump_exit_pending=true
    log('JUMP_EXIT_REQUESTED: 3 OnJumped signals within 5s; scheduling guarded native return')
    -- NUNCA invocar Possess() no meio do OnJumped, para evitar reentrancia.
    local scheduled=pcall(function()
        if type(ExecuteInGameThread)~='function' then error('ExecuteInGameThread unavailable') end
        ExecuteInGameThread(function()
            if trial~=state then return end
            local success,result=pcall(function()return restore_trial('triple_jump_native')end)
            if success then log(result)
            else log('JUMP_EXIT_FAILED: unexpected Lua error during restore; TXT RETURN fallback; do not spam') end
            if trial==state then
                -- Nao tenta repetidamente Possess nativo sem inspecao.
                state.jump_exit_pending=true
            end
        end)
    end)
    if not scheduled then
        log('JUMP_EXIT_FAILED: scheduling unavailable; use TXT RETURN; no native call by jump handler')
        state.jump_exit_pending=false
        state.jump_times={}
    end
end

-- v1.8.4: SEM watchdog de desconexao. Nada procura controladores periodicamente
-- enquanto o admin possui um Pal. Reconciliacao SO apos comando autenticado
-- no chat ou pelo arquivo TXT (STATUS/GHOST/CLEANUP/CONFIRM).
-- NAO invoca Possess. So verifica se o jogo JA devolveu um pawn humano e
-- opcionalmente rastreia o antigo corpo, SEM o remover automaticamente.
local function reconcile_human_on_demand(reason)
    if not trial or trial.restoring then return end
    local state=trial
    local pc=verified_owner_online(false)
    if not pc then return end -- offline ou identidade ambigua: nenhuma mutacao
    local ok,pawn=pcall(function() return pc:K2_GetPawn() end)
    if not ok or not pawn_matches_human(pawn,state.human_class) then
        return -- ainda no Pal ou pawn nao verificavel
    end
    if state.focus_baseline then
        log(restore_trial('reconcile_'..reason))
        return -- same rollback path; never discard an un-restored direct session
    end
    local old_pc_key,new_pc_key=state.pc_key,actor_key(pc)
    local old_human_key,new_human_key=actor_key(state.human),actor_key(pawn)
    if old_pc_key and new_pc_key and old_pc_key~=new_pc_key then
        state.offline=true
    end
    if old_human_key and new_human_key and old_human_key~=new_human_key then
        state.offline=true
    end
    -- Se o jogo carregou novo humano, apenas RASTREAR o humano antigo
    -- previamente guardado nessa sessao. Nunca localizar por nome/aparencia.
    track_old_human_if_distinct(state,pawn)
    range_restore_actor(state)
    if not recovery_journal_write(false) then
        log('REJOIN_HUMAN_UNCERTAIN: game already controls human, but journal SAFE write failed; no native Possess; do not repeat trial')
        return
    end
    trial=nil;recovery_lock=false;recovery_class=nil
    if state.temporary_boss==true then
        log('BOSSRETURN_HUMAN_ALREADY_PRESENT: SAFE journal; reason='..reason)
        if type(boss_cleanup_after_return)=='function' then log(boss_cleanup_after_return('reconcile_human')) end
    else
        if type(pal_control.dead_pal_cleanup_after_return)=='function' then pal_control.dead_pal_cleanup_after_return(state,'reconcile_human') end
        log('REJOIN_HUMAN_VERIFIED: game already controls human; journal SAFE; no native Possess; old ghost only if tracked; reason='..reason)
    end
end
-- v1.11.11: teste separado de UMA action de ataque presente no jogo.
-- BP_ActionShootSkill_C existe em dumps publicos do Palworld, mas sua existencia
-- nesta build/num Pal especifico nao esta comprovada. Nenhuma busca global.
-- ATTACKVER nao executa ataque; ATTACK1 faz maximo uma chamada nativa SOMENTE
-- se a classe ja existe em memoria, foi identificada e a sessao esta integra.
pal_control.attack_fixed_state={class='BP_ActionShootSkill_C',last_call_ts=nil,delay_seconds=10,arm_seconds=90}
function pal_control.fixed_action_type_name(cls)
    if not valid(cls) then return nil end
    local ok,name=pcall(function()return cls:GetFName():ToString()end)
    if ok and type(name)=='string' and #name<128 then return name end
    return nil
end
function pal_control.fixed_action_find_class()
    -- v1.11.11: StaticFindObject com nome curto pode falhar mesmo quando
    -- a UBlueprintGeneratedClass esta carregada. Consulta alternativa pontual
    -- FindObject(classe curta, nome curto) SEM iterar arrays/objetos do mundo,
    -- SEM carregar asset e SEM executar acao. Fail-closed se nao confirmar.
    local wanted=pal_control.attack_fixed_state.class
    local cls=nil
    local origin='none'
    if type(StaticFindObject)=='function' then
        local ok,result=pcall(function()return StaticFindObject(nil,nil,wanted,true)end)
        if ok and valid(result) then cls=result;origin='StaticFindObject_short' end
    end
    if not valid(cls) and type(FindObject)=='function' then
        local ok,result=pcall(function()return FindObject('BlueprintGeneratedClass',wanted)end)
        if ok and valid(result) then cls=result;origin='FindObject_BlueprintGeneratedClass' end
    end
    if not valid(cls) and type(FindObject)=='function' then
        local ok,result=pcall(function()return FindObject('Class',wanted)end)
        if ok and valid(result) then cls=result;origin='FindObject_Class' end
    end
    if not valid(cls) then
        return nil,'not_resolved_via_static_or_short_class_lookup_no_asset_loaded'
    end
    local name=pal_control.fixed_action_type_name(cls)
    if name~=wanted then return nil,'class_identity_unverified' end
    local type_name=pawn_class_name(cls)
    if type_name~='BlueprintGeneratedClass' and type_name~='Class' then
        return nil,'not_UClass_type_'..tostring(type_name)
    end
    -- Classe deve herdar UPalActionBase: se a heranca nao puder ser lida,
    -- nao permitir ATTACK1; nenhum pal extra e acessado.
    if type(StaticFindObject)~='function' then return nil,'pal_action_base_lookup_unavailable' end
    local okbase,base=pcall(function()return StaticFindObject('/Script/Pal.PalActionBase')end)
    if not okbase or not valid(base) then return nil,'pal_action_base_unavailable' end
    local okay,child=pcall(function()return cls:IsChildOf(base)end)
    if not okay or child~=true then return nil,'not_verified_subclass_of_PalActionBase' end
    return cls,'ok_via_'..origin
end
function pal_control.fixed_attack_command(action)
    local s=trial
    if not s or s.direct_control~=true or s.pal_lost or s.target_kind~='PAL'
        or not pal_control.exact(s,true) or recovery_lock~=true then
        return 'ATTACK_FIXED_BLOCKED: owner_original_wild_pal_not_verified; zero_native_calls=true'
    end
    -- A referencia deve continuar a ser o MESMO Pal que o PC atualmente possui.
    if not valid(s.pc) or not valid(s.pal) or not valid(s.human) then
        return 'ATTACK_FIXED_BLOCKED: original_session_references_unavailable'
    end
    local okpawn,pawn=pcall(function()return s.pc:K2_GetPawn()end)
    if not okpawn or not valid(pawn) or actor_key(pawn)~=actor_key(s.pal) then
        return 'ATTACK_FIXED_BLOCKED: controller_no_longer_possesses_same_pal'
    end
    local okcomp,comp=pcall(function()return s.pal.ActionComponent end)
    if not okcomp or not valid(comp) then
        return 'ATTACK_FIXED_BLOCKED: original_pal_ActionComponent_unavailable'
    end
    if not pal_control.api('/Script/Pal.PalActionComponent:PlayAction') then
        return 'ATTACK_FIXED_BLOCKED: native_PlayAction_unavailable'
    end
    local class,reason=pal_control.fixed_action_find_class()
    log('ATTACK_FIXED_PREFLIGHT: class='..pal_control.attack_fixed_state.class
        ..'; class_readback='..tostring(reason)
        ..'; own_pal_controller_verified=true; equipped_waza_untouched=true'
        ..'; no_global_object_scan=true; no_automatic_attack=true')
    if not valid(class) then
        return 'ATTACK_FIXED_BLOCKED: '..tostring(reason)..'; no_native_call=true'
    end
    local now=os.time()
    if type(now)~='number' then
        return 'ATTACK_FIXED_BLOCKED: server_time_unavailable'
    end
    if action=='ATTACKVER' then
        s.fixed_attack_armed_at=now
        return 'ATTACK_FIXED_READY: native_class_confirmed; NO_ATTACK_EXECUTED=true; request ATTACK1 within 90s only if test_server_is_safe'
    end
    if action~='ATTACK1' then return 'ATTACK_FIXED_BLOCKED: unknown_command' end
    if s.fixed_attack_called or s.fixed_attack_consumed then
        return 'ATTACK_FIXED_BLOCKED: one_attack_request_per_possession_session; no_native_call=true'
    end
    if not s.fixed_attack_armed_at or now<s.fixed_attack_armed_at or
       now-s.fixed_attack_armed_at>pal_control.attack_fixed_state.arm_seconds then
        return 'ATTACK_FIXED_BLOCKED: run ATTACKVER first_in_same_session; no_native_call=true'
    end
    if pal_control.attack_fixed_state.last_call_ts and now-pal_control.attack_fixed_state.last_call_ts<pal_control.attack_fixed_state.delay_seconds then
        return 'ATTACK_FIXED_BLOCKED: global_10_second_interval; no_native_call=true'
    end
    -- Consome tentativa ANTES do nativo; pcall NAO captura crashes C++/engine.
    s.fixed_attack_consumed=true
    pal_control.attack_fixed_state.last_call_ts=now
    log('ATTACK_FIXED_NATIVE_PRECALL: action=BP_ActionShootSkill_C; session_exact=true; one_call_only=true; target=nil; damage_write=false; WARNING_NATIVE_CRASH_POSSIBLE=true')
    local called,created=pcall(function()return comp:PlayAction(nil,class)end)
    if not called then
        log('ATTACK_FIXED_NATIVE_LUA_ERROR: no_retries=true; return_to_human=true')
        return 'ATTACK_FIXED_FAILED: lua_exception; never_repeat_in_this_session'
    end
    s.fixed_attack_called=true
    log('ATTACK_FIXED_NATIVE_RESULT: native_call_returned=true; instance_valid='..tostring(valid(created))
        ..'; server_call_not_proof_of_animation_or_damage=true; Xbox_confirmation_required=true')
    return 'ATTACK_FIXED_CALLED_ONCE: check_in_game_animations_and_UE4SS_log; do_not_spam'
end

-- v1.11.4: investigar PlaySkill com prova observavel da acao/cooldown.
-- API do SDK: PlaySkill(int32 SlotID) retorna bool. False significa pedido rejeitado;
-- true ainda nao comprova animacao/dano Xbox. Nao chamar outra skill automaticamente.
-- Somente o Pal EXATO possuido pelo admin, com uso unico por comando.
local function skill_snapshot(state, slot_zero)
    if not state or state~=trial or not state.direct_control or state.pal_lost
       or state.target_kind~='PAL' or not pal_control.exact(state,true) then
        return nil
    end
    local result={slot=slot_zero, valid='unavailable', ready='unavailable',
                  cooldown='unavailable', action='unavailable', action_key=nil,
                  slot_exists=false, component_exists=false}
    if valid(state.ai) and actor_key(state.ai)==state.ai_key then
        local ok,skills=pcall(function()return state.ai.SkillSlot end)
        if ok and valid(skills) then
            result.slot_exists=true
            local a,b=pcall(function()return skills:IsValidSkill(slot_zero)end)
            if a then result.valid=tostring(b) end
            local c,d=pcall(function()return skills:IsCoolTimeFinish(slot_zero)end)
            if c then result.ready=tostring(d) end
            local e,f=pcall(function()return skills:GetCoolTime(slot_zero)end)
            if e and type(f)=='number' and f==f and math.abs(f)<100000 then
                result.cooldown=string.format('%.2f',f)
            end
        end
    end
    -- Ler somente o componente do controller Wild ORIGINAL rastreado; nunca usar um
    -- FindObjects amplo, atuar em outro player ou gerar acao substituta.
    local ok,component=pcall(function()return state.ai:GetAIActionComponent()end)
    if not ok or not valid(component) then
        ok,component=pcall(function()return state.ai.AIActionComponent end)
    end
    if ok and valid(component) then
        result.component_exists=true
        local called,action=pcall(function()return component:GetCurrentAction_BP()end)
        if called then
            if valid(action) then
                result.action_key=actor_key(action)
                result.action=pawn_class_name(action) or 'native_action_unnamed'
            else
                result.action='none'
            end
        end
    end
    return result
end

local function skill_report(snapshot)
    if not snapshot then return 'session_not_verified' end
    return 'native_slot='..tostring(snapshot.slot)..'; ai_slot_exists='..tostring(snapshot.slot_exists)
        ..'; slot_valid='..snapshot.valid..'; cooldown_ready='..snapshot.ready
        ..'; cooldown_seconds='..snapshot.cooldown..'; pal_action_component='..tostring(snapshot.component_exists)
        ..'; current_action='..snapshot.action
end

local function skill_delayed_observe(state,slot_zero,baseline,ms)
    if type(ExecuteWithDelay)~='function' or type(ExecuteInGameThread)~='function' then
        log('SKILL_OBSERVE_UNAVAILABLE: timed_game_thread_api_missing; no_retry=true')
        return
    end
    local scheduled=pcall(function()
        ExecuteWithDelay(ms,function()
            local dispatched=pcall(function()
                ExecuteInGameThread(function()
                    if trial~=state or not pal_control.exact(state,true) then
                        log('SKILL_OBSERVE_CANCELLED: session_changed_or_returned; no_actor_modified=true')
                        return
                    end
                    local after=skill_snapshot(state,slot_zero)
                    if not after then
                        log('SKILL_OBSERVE_CANCELLED: same_pal_identity_not_verified')
                        return
                    end
                    local action_changed=baseline and after.action_key~=baseline.action_key
                    local cooldown_started=baseline and baseline.ready=='true' and after.ready=='false'
                    log('SKILL_OBSERVE_'..tostring(ms)..'MS: '..skill_report(after)
                        ..'; action_changed='..tostring(action_changed)
                        ..'; cooldown_started='..tostring(cooldown_started)
                        ..'; no_damage_write=true; Xbox_visual_confirmation_required=true')
                    log('SKILL_ACTOR_OBSERVE_'..tostring(ms)..'MS: '..cvg_actor_skill_probe(state.pal,state.ai))
                end)
            end)
            if not dispatched then log('SKILL_OBSERVE_FAILED: cannot_dispatch_game_thread') end
        end)
    end)
    if not scheduled then log('SKILL_OBSERVE_FAILED: timer_registration_failed') end
end

-- v1.11.8: caminho alternativo para ataque real do Pal: Waza do PROPRIO ator,
-- nao os slots do controlador IA (vazios mesmo ANTES da possessao em Xbox).
-- Referencias do SDK: IndividualParameter:GetEquipWaza();
-- StaticCharacterParameterComponent.WazaActionInstancedMap;
-- PalActionComponent:PlayAction(AActor*, TSubclassOf<UPalActionBase>).
-- ForEach e TMap:Find sao parte da API UE4SS, mas suporte concreto dessa build
-- e comportamento de Blueprint dependem de teste real. Todos os fallbacks falham
-- fechados; nenhuma classe de ataque e inventada.
local cvg_waza_command
do
local function cvg_wa_read_number(value)
    local current=value
    if type(current)~='number' then
        local ok,x=pcall(function()return current:get()end)
        if ok then current=x end
    end
    if type(current)=='number' and current==current and current>=0
       and current<=65535 and current%1==0 then return current end
    return nil
end
local function cvg_wa_probe(s)
    -- v1.11.11.10: introspeccao defensiva, SEM cast automatico ou escrita em arrays.
    -- O GetEquipWaza da build CVG retornou count=1 mas arr:ForEach falhou.
    -- Tentar um metodo de cada vez, somente nas entradas anunciadas pelo tamanho.
    local d={reason='unknown', ids={}, classes={}, actor_component=nil,
        map_count='unavailable', equipped_count='unavailable',
        array_status='unreadable', map_status='not_attempted',
        array_type='unknown', array_path='none', array_error='none'}
    if not s or not s.direct_control or s.pal_lost or s.target_kind~='PAL'
        or not pal_control.exact(s,true) or not valid(s.pal) then
        d.reason='not_same_possessed_original_pal';return d
    end
    local ok,parm=pcall(function()return s.pal.CharacterParameterComponent end)
    if not ok or not valid(parm) then d.reason='character_parameter_missing';return d end
    local got,ind=pcall(function()return parm:GetIndividualParameter()end)
    if not got or not valid(ind) then d.reason='individual_parameter_missing';return d end
    local okarr,arr=pcall(function()return ind:GetEquipWaza()end)
    if not okarr or arr==nil then d.reason='equip_waza_read_failed';return d end
    d.array_type=type(arr)
    d.equipped_count=cvg_skill_array_count(arr)
    local n=tonumber(d.equipped_count)
    if n==nil or n<0 or n>8 or n%1~=0 then
        d.reason='equip_count_unknown_or_too_large';return d
    end
    -- A pesquisa do ActionComponent e independente da iteracao do array.
    local okact,act=pcall(function()return s.pal.ActionComponent end)
    if okact and valid(act) then d.actor_component=act end
    if n==0 then d.reason='no_equip_waza';d.array_status='empty';return d end

    local for_ids={}
    local forcount=0
    local for_ok,for_err=pcall(function()
        arr:ForEach(function(index,element)
            local id=cvg_wa_read_number(element)
            if id and type(index)=='number' and index>=0 and index<=8 then
                -- API docs de versoes diferentes usam base 0 ou 1; guardar bruto.
                for_ids[index]=id
                forcount=forcount+1
            end
        end)
    end)
    if for_ok and forcount>0 then
        if for_ids[0]~=nil then
            for i=1,math.min(n,3) do d.ids[i]=for_ids[i-1] end
            d.array_path='foreach_zero_based'
        else
            for i=1,math.min(n,3) do d.ids[i]=for_ids[i] end
            d.array_path='foreach_one_based'
        end
        d.array_status='ForEach_OK'
    else
        d.array_status=for_ok and 'ForEach_empty_or_nonnumeric' or 'ForEach_failed'
        if not for_ok then d.array_error=tostring(for_err):gsub('[\r\n]',' '):sub(1,130) end
    end

    local ids_seen=0
    for i=1,3 do if d.ids[i]~=nil then ids_seen=ids_seen+1 end end
    if ids_seen==0 then
        -- Documentacao UE4SS atual aceita TArray[index]. Nenhuma mutacao.
        -- Nunca inspecionar alem de n elementos; testar base 1 e depois base 0.
        for _,base in ipairs({1,0}) do
            local probe={};local count=0;local idx_error='none'
            for i=1,math.min(n,3) do
                local index=base==1 and i or i-1
                local ix_ok,entry=pcall(function()return arr[index]end)
                if ix_ok then
                    probe[i]=cvg_wa_read_number(entry)
                    if probe[i]~=nil then count=count+1 end
                elseif idx_error=='none' then
                    idx_error=tostring(entry):gsub('[\r\n]',' '):sub(1,130)
                end
            end
            if count>0 then
                for i=1,3 do d.ids[i]=probe[i] end
                d.array_path=base==1 and 'indexed_one_based' or 'indexed_zero_based'
                break
            end
            if idx_error~='none' then d.array_error=idx_error end
        end
    end

    ids_seen=0
    for i=1,3 do if d.ids[i]~=nil then ids_seen=ids_seen+1 end end
    if ids_seen==0 then
        d.reason='equip_ids_not_decoded';return d
    end
    -- So consultar classes do mesmo Pal para IDs que vieram de GetEquipWaza.
    local okstatic,static=pcall(function()return s.pal.StaticCharacterParameterComponent end)
    if not okstatic or not valid(static) then d.reason='static_character_component_missing';return d end
    local okmap,map=pcall(function()return static.WazaActionInstancedMap end)
    if not okmap or map==nil then d.reason='waza_class_map_unavailable';return d end
    local counted,m=pcall(function()return #map end)
    if counted and type(m)=='number' and m>=0 and m<100000 then d.map_count=tostring(m) end
    d.map_status='map_found'
    for idx=1,3 do
        local id=d.ids[idx]
        if id and id>0 then
            local found,val=pcall(function()return map:Find(id)end)
            if found and val then
                local okget,cls=pcall(function()return val:get()end)
                if okget and valid(cls) then d.classes[idx]=cls end
                if valid(val) and not valid(d.classes[idx]) then d.classes[idx]=val end
            end
        end
    end
    d.reason='ok';return d
end
local function cvg_waza_probe_summary(d)
    local parts={}
    for idx=1,8 do
        if d.ids[idx]~=nil then parts[#parts+1]=tostring(idx)..':'..tostring(d.ids[idx]) end
    end
    local mapped={}
    for idx=1,3 do
        mapped[#mapped+1]=tostring(idx)..'='..tostring(valid(d.classes[idx]))
    end
    return 'reason='..tostring(d.reason)..'; equip_count='..tostring(d.equipped_count)
        ..'; equip_ids='..table.concat(parts,',')
        ..'; array='..tostring(d.array_status)
        ..'; array_type='..tostring(d.array_type)
        ..'; read_path='..tostring(d.array_path)
        ..'; array_error='..tostring(d.array_error)
        ..'; waza_map='..tostring(d.map_status)
        ..'; waza_class_map_size='..tostring(d.map_count)
        ..'; first3_action_class='..table.concat(mapped,',')
        ..'; own_ActionComponent='..tostring(valid(d.actor_component))
        ..'; own_original_pal_only=true; no_writes=true'
end
local function cvg_waza_action_status(s)
    if not s or not pal_control.exact(s,true) then return 'session_changed' end
    local ok,comp=pcall(function()return s.pal.ActionComponent end)
    if not ok or not valid(comp) then return 'pal_component_unavailable' end
    local g,action=pcall(function()return comp:GetCurrentAction()end)
    local name=g and (pawn_class_name(action) or 'none') or 'read_failed'
    local e,empty=pcall(function()return comp:ActionIsEmpty()end)
    local typ,actiontype=pcall(function()return comp:GetCurrentActionType(false)end)
    return 'action='..name..'; empty='..(e and tostring(empty) or 'unknown')
        ..'; type='..(typ and tostring(actiontype) or 'unknown')
end
local function cvg_waza_observe(s,delay)
    local ok=pcall(function()
        ExecuteWithDelay(delay,function()
            ExecuteInGameThread(function()
                if s~=trial or not pal_control.exact(s,true) then
                    log('WAZA_OBSERVE_CANCELLED: session_changed_or_returned');return
                end
                log('WAZA_OBSERVE_'..tostring(delay)..'MS: '..cvg_waza_action_status(s)
                    ..'; no_direct_damage_write=true; Xbox_visual_confirmation_required=true')
            end)
        end)
    end)
    if not ok then log('WAZA_OBSERVE_UNAVAILABLE: delay_api_failed') end
end
cvg_waza_command = function(action)
    local idx=tonumber(action:match('^WAZA([123])$'))
    if not trial or not trial.direct_control or trial.pal_lost
        or trial.target_kind~='PAL' or not pal_control.exact(trial,true) then
        return 'WAZA_BLOCKED: must_possess_own_original_wild_pal; no_native_call=true'
    end
    local s=trial
    local d=cvg_wa_probe(s)
    log('WAZA_READONLY: '..cvg_waza_probe_summary(d))
    if action=='WAZACHECK' then
        return 'WAZACHECK_DONE: native_classes_in_log; zero_attacks_invoked=true; inspect_WAZA_READONLY'
    end
    if not idx then return 'WAZA_BLOCKED: unknown_slot; no_native_call=true' end
    if recovery_lock~=true then return 'WAZA_BLOCKED: journal_not_ACTIVE; no_native_call=true' end
    if d.reason~='ok' or not valid(d.actor_component) or not valid(d.classes[idx]) then
        return 'WAZA_BLOCKED: equipped_waza_action_class_unavailable_for_slot_'..idx
            ..'; no_native_call=true; see_WAZA_READONLY'
    end
    if not pal_control.api('/Script/Pal.PalActionComponent:PlayAction') then
        return 'WAZA_BLOCKED: PalActionComponent_PlayAction_not_reflected; no_native_call=true'
    end
    local now=os.time()
    if type(now)~='number' or (skill_last_call_ts and now-skill_last_call_ts<SKILL_MIN_INTERVAL_SECONDS) then
        return 'WAZA_BLOCKED: max_one_native_attack_request_every_3s; no_native_call=true'
    end
    local actionclass=d.classes[idx]
    local clsname=pawn_class_name(actionclass) or 'UClass'
    skill_last_call_ts=now
    log('WAZA_PRECALL: slot='..idx..'; waza_id='..tostring(d.ids[idx])
        ..'; native_action_class='..clsname..'; '..cvg_waza_action_status(s)
        ..'; owner_pal_identity_verified=true; no_skill_slot_or_damage_write=true')
    -- Apenas um pedido. NUNCA chamar PlaySkill/PlayAction por fallback ou em loop.
    -- AActor* TargetActor = nil: nao escolhe nem altera qualquer outro ator.
    pal_control.native_attack_self_cast=true
    local called,created=pcall(function()return d.actor_component:PlayAction(nil,actionclass)end)
    pal_control.native_attack_self_cast=false
    if not called then
        log('WAZA_NATIVE_ERROR: slot='..idx..'; no_retry=true; use_RETURN_if_Xbox_stuck')
        return 'WAZA_NATIVE_ERROR: PlayAction_experimental_failed; check_logs_before_retry'
    end
    local present=valid(created)
    log('WAZA_NATIVE_RESULT: slot='..idx..'; action_instance_returned='..tostring(present)
        ..'; '..cvg_waza_action_status(s)..'; no_claim_of_Xbox_animation_or_damage=true')
    if type(ExecuteWithDelay)=='function' and type(ExecuteInGameThread)=='function' then
        cvg_waza_observe(s,350);cvg_waza_observe(s,1200)
    end
    return 'WAZA_ATTEMPT_DONE: native_PlayAction_called_once=true; instance_returned='..tostring(present)
        ..'; Xbox_visual_check_required=true; no_automatic_damage_or_retry=true'
end
-- Only one instance of the existing, normally DISABLED WAZA helper is exposed.
-- It reads this EXACT possessed Pal's own equipped waza, never a static ID.
pal_control.own_waza_command=cvg_waza_command
end -- scope local helpers (Lua main chunk max local variables)

local function possessed_pal_skill(action)
    local slot=tonumber(action:match('^SKILL([123])$'))
    if not trial or trial.target_kind~='PAL' or not trial.direct_control or trial.pal_lost then
        return 'SKILL_BLOCKED: own_original_wild_pal_must_be_possessed; no_native_call=true'
    end
    if not pal_control.exact(trial,true) then
        return 'SKILL_BLOCKED: original_owner_pal_identity_unverified; no_native_call=true'
    end
    if action=='SKILLCHECK' then
        local entries={}
        for idx=0,3 do
            local snap=skill_snapshot(trial,idx)
            entries[#entries+1]=skill_report(snap)
        end
        log('SKILLCHECK_NATIVE: '..table.concat(entries,' | '))
        log('SKILL_ACTOR_READONLY: '..cvg_actor_skill_probe(trial.pal,trial.ai))
        return 'SKILLCHECK_READY: PlaySkill_reflected='..tostring(pal_control.api('/Script/Pal.PalPlayerController:PlaySkill'))
            ..'; PlaySkill_returns_bool_in_public_SDK=true; 1to0_2to1_3to2_mapping_unverified=true'
            ..'; no_native_attack_called=true; see_SKILLCHECK_NATIVE'
    end
    if not slot then return 'SKILL_BLOCKED: invalid_slot; no_native_call=true' end
    if recovery_lock~=true then
        return 'SKILL_BLOCKED: journal_not_ACTIVE; no_native_call=true'
    end
    local now=os.time()
    if type(now)~='number' or (skill_last_call_ts and now-skill_last_call_ts<SKILL_MIN_INTERVAL_SECONDS) then
        return 'SKILL_BLOCKED: max_one_native_request_every_3s; no_native_call=true'
    end
    if not pal_control.api('/Script/Pal.PalPlayerController:PlaySkill') then
        return 'SKILL_BLOCKED: native_PlaySkill_not_reflected; no_native_call=true'
    end
    local session=trial
    local index=slot-1
    local before=skill_snapshot(session,index)
    if not before then return 'SKILL_BLOCKED: cannot_read_original_pal_before_call' end
    -- Não alterar slot, cooldown, IA, equipamento ou habilidade do Pal;
    -- simplesmente acionar o metodo nativo existente UMA VEZ.
    skill_last_call_ts=now
    log('SKILL_PRECALL: '..skill_report(before)..'; owner_original_pal_only=true; no_forced_damage=true')
    log('SKILL_ACTOR_PRECALL_READONLY: '..cvg_actor_skill_probe(session.pal,session.ai))
    local success,value=pcall(function()return session.pc:PlaySkill(index)end)
    if not success then
        return 'SKILL_NATIVE_ERROR: slot='..slot..'; native_call_failed; no_automatic_retry=true; use_RETURN_if_stuck'
    end
    -- O metodo PlaySkill retorna bool: false=rejeitado.
    -- Um eventual true tambem nao comprova animacao/dano no Xbox.
    log('SKILL_NATIVE_INVOKED: slot='..slot..'; native_index='..index
        ..'; result_type='..type(value)..'; result_value='..tostring(value)
        ..'; no_claim_of_attack_or_damage=true; Xbox_unverified=true')
    if type(value)=='boolean' and value==false then
        log('SKILL_NATIVE_REJECTED: slot='..tostring(slot)..'; native_result=false; skill_not_started=true; no_fallback_attack_or_damage=true')
    end
    skill_delayed_observe(session,index,before,250)
    skill_delayed_observe(session,index,before,1100)
    if type(value)=='boolean' and value==false then
        return 'SKILL_REJECTED: PlaySkill retornou FALSE para slot '..slot..'; nenhum ataque confirmado; veja SKILL_ACTOR_READONLY e SKILL_OBSERVE no log'
    end
    return 'SKILL_TEST_SENT: slot='..slot..'; native_PlaySkill_called_once=true; response_is_not_proof_of_damage=true; inspect_SKILL_OBSERVE_250MS_1100MS_and_Xbox'
end

-- v1.11.11.6: teste exclusivo da habilidade Paldium Shot (EPalWazaID=341)
-- do ASTRALYM HARD+ (GYM_WorldTreeDragon_2) do template enviado pelo admin.
-- NAO altera TRIAL/Possess, o Pal, EquipWaza, HP, cooldown, rede ou IA.
-- A habilitacao da execucao e DEFINIDA NO ARQUIVO; nenhum comando a muda.
-- Nao confundir ID da habilidade 341 com indice de PlaySkill(0..2).
-- WARNING: acesso a UEnum/TMap e PlayAction podem causar crash nativo mesmo com pcall.
function pal_control.astralym_shot_341(command)
    local function report(message)
        log('ASTRALYM341_'..message)
        -- Anota somente eventos de comando, sem dados do jogador ou posicao.
        pcall(function()
            local f=io.open('Mods/CVGBossControl/cvg_astralym_shot_v11116.log','a')
            if f then
                f:write('ASTRALYM341_'..message..'\n')
                f:flush()
                f:close()
            end
        end)
        return 'ASTRALYM341_'..message
    end
    local s=trial
    if not s or not s.direct_control or s.pal_lost or s.target_kind~='PAL'
        or not pal_control.exact(s,true) or not valid(s.pal) then
        return report('BLOCKED: verified_owned_Pal_possession_required; no_skill_call=true')
    end
    local ok_param,parm=pcall(function()return s.pal.CharacterParameterComponent end)
    if not ok_param or not valid(parm) then
        return report('BLOCKED: character_parameter_unavailable; no_skill_call=true')
    end
    local ok_ind,ind=pcall(function()return parm:GetIndividualParameter() end)
    if not ok_ind or not valid(ind) then
        return report('BLOCKED: individual_parameter_unavailable; no_skill_call=true')
    end
    -- Apenas o PalID exato do template do evento, nao so nickname/classe/reticulo.
    if not pal_control.api('/Script/Pal.PalIndividualCharacterParameter:GetCharacterID') then
        return report('BLOCKED: GetCharacterID_not_reflected; no_skill_call=true')
    end
    local id_ok,id=pcall(function()return ind:GetCharacterID()end)
    if not id_ok or id==nil then
        return report('BLOCKED: GetCharacterID_failed; no_skill_call=true')
    end
    local name_ok,pal_id=pcall(function()
        if type(id)=='string' then return id end
        return id:ToString()
    end)
    if not name_ok or type(pal_id)~='string' then
        return report('BLOCKED: PalID_FName_unreadable; no_skill_call=true')
    end
    if pal_id~='GYM_WorldTreeDragon_2' then
        return report('BLOCKED: PalID_not_GYM_WorldTreeDragon_2; no_skill_call=true')
    end
    report('PAL_VERIFIED: PalID=GYM_WorldTreeDragon_2; skill=Unique_WorldTreeDragon_PaldiumShot; waza_id=341; source=template_plus_enum_dump; same_possessed_Pal=true')
    -- Check separado da execucao; ID341 nao e escolhido por posicao no ActiveSkills.
    local map_ok,static=pcall(function()return s.pal.StaticCharacterParameterComponent end)
    if not map_ok or not valid(static) then
        return report('BLOCKED: static_character_parameter_missing; no_skill_call=true')
    end
    local m_ok,map=pcall(function()return static.WazaActionInstancedMap end)
    if not m_ok or map==nil then
        return report('BLOCKED: WazaActionInstancedMap_missing; no_skill_call=true')
    end
    local find_ok,entry=pcall(function()return map:Find(341)end)
    if not find_ok or entry==nil then
        return report('BLOCKED: waza_341_class_not_found; no_skill_call=true')
    end
    local cls=nil
    local un_ok,un=pcall(function()return entry:get() end)
    if un_ok and valid(un) then cls=un
    elseif valid(entry) then cls=entry end
    if not valid(cls) then
        return report('BLOCKED: waza_341_action_class_unusable; no_skill_call=true')
    end
    local a_ok,comp=pcall(function()return s.pal.ActionComponent end)
    if not a_ok or not valid(comp) then
        return report('BLOCKED: own_Pal_ActionComponent_unavailable; no_skill_call=true')
    end
    if not pal_control.api('/Script/Pal.PalActionComponent:PlayAction') then
        return report('BLOCKED: PlayAction_not_reflected; no_skill_call=true')
    end
    report('CLASS_READY: waza_id=341; exact_owner_pal=true; native_action_class_found=true; no_attack_started=true')
    if command=='ASTRALYMSHOTCHECK' then
        return report('CHECK_DONE: no_attack_called=true')
    end
    if command~='ASTRALYMSHOT' or CVG_ASTRALYM_SHOT_NATIVE_ENABLED~=true then
        return report('BLOCKED: casting_disabled_in_this_profile; no_attack_called=true')
    end
    if recovery_lock~=true or s~=trial or not pal_control.exact(s,true) then
        return report('BLOCKED: journal_or_session_changed; no_attack_called=true')
    end
    -- Exatamente uma chamada por pedido TXT, sem loops/repeticoes/fallback.
    report('PRECALL: calling_PlayAction_one_time; target_actor=nil; skill_id=341; NATIVE_CRASH_POSSIBLE=true')
    pal_control.native_attack_self_cast=true
    local called,result=pcall(function()return comp:PlayAction(nil,cls)end)
    pal_control.native_attack_self_cast=false
    if not called then
        return report('NATIVE_LUA_ERROR: action_not_confirmed; no_auto_retry=true')
    end
    return report('NATIVE_RETURN: called_once=true; action_object_valid='..tostring(valid(result))
        ..'; Xbox_animation_and_damage_unverified=true')
end

-- v1.11.11.14: classe da habilidade por PalID EXATO.
-- Nao chama PlaySkill, GetEquipWaza, ForEach, nem le array TArray.
-- Nao faz dano artificial, mudanca de skill, auto-retry ou loops.
-- PlayAction pode causar crash nativo mesmo quando protegido por pcall.
-- CVG TARGET LOCK v27: manual lock only. On-demand scan of at most 512
-- nonplayer AI-controlled actors, inside 35m/65deg forward cone of owned pawn.
-- NO Xbox camera reticle, no automatic combat, no client camera/input writes.
-- The lock holds a single actor reference; it is rechecked before each shot.
pal_control.TARGET_SELECT_RADIUS_CM=3500
pal_control.TARGET_RETAIN_RADIUS_CM=6000
pal_control.TARGET_CONE_DEG=65
pal_control.TARGET_SCAN_LIMIT=512
function pal_control.target_clear(reason)
    pal_control.target_lock=nil
    pal_control.target_last_result=tostring(reason or 'ALVO_DESMARCADO'):sub(1,110)
end
function pal_control.target_verify(st)
    local t=pal_control.target_lock
    if not t then return false,'SEM_ALVO' end
    if not st or trial~=st or st.direct_control~=true or st.restoring or st.pal_lost
       or st.offline or st.jump_exit_pending or recovery_lock~=true
       or pal_control.mobile_tracked_trial~=st
       or t.session~=pal_control.mobile_session_token
       or not pal_control.exact(st,true) then return false,'SESSAO_INVALIDA' end
    if not valid(t.actor) or actor_key(t.actor)~=t.actor_key or t.actor==st.pal or t.actor==st.human then
        return false,'ATOR_NAO_EXISTE'
    end
    -- This check explicitly rejects human players (PalPlayerCharacter) and
    -- creatures that changed controller, died or lost server authority.
    if pal_control.target_kind(t.actor)~=t.kind then return false,'ALVO_NAO_E_INIMIGO_AI' end
    local ok,controller=pcall(function()return t.actor.Controller end)
    if not ok or not valid(controller) or actor_key(controller)~=t.controller_key then
        return false,'CONTROLE_ALVO_ALTERADO'
    end
    local good,a,b=pcall(function()return st.pal:K2_GetActorLocation(),t.actor:K2_GetActorLocation()end)
    if not good or not a or not b then return false,'POSICAO_INDISPONIVEL' end
    local dx,dy,dz=b.X-a.X,b.Y-a.Y,b.Z-a.Z
    local distance=math.sqrt(dx*dx+dy*dy+dz*dz)
    if not distance or distance~=distance or distance<1 or distance>pal_control.TARGET_RETAIN_RADIUS_CM then
        return false,'ALVO_FORA_DE_ALCANCE'
    end
    return true,{dx=dx,dy=dy,dz=dz,distance=distance,name=t.name,kind=t.kind,actor=t.actor}
end
function pal_control.target_action(action)
    local st=trial
    if action=='TARGETCLEAR' then
        pal_control.target_clear('ALVO_DESMARCADO')
        log('CVG_TARGET_LOCK: status=CLEARED; no_native_rotation=true')
        return 'TARGET_CLEARED'
    end
    if not st or st.direct_control~=true or (st.target_kind~='PAL' and st.target_kind~='NPC')
        or st.restoring or st.offline or st.pal_lost or recovery_lock~=true
        or not pal_control.exact(st,true) or pal_control.mobile_tracked_trial~=st then
        return 'TARGET_BLOCKED_SEM_POSSE_VALIDADA'
    end
    if action=='TARGETSTATUS' then
        local ok,info=pal_control.target_verify(st)
        if not ok then pal_control.target_clear(info);return 'TARGET_'..info end
        return 'TARGET_LOCKED_'..info.name..'_'..tostring(math.floor(info.distance/100))..'M'
    end
    if action~='TARGETLOCK' then return 'TARGET_COMANDO_INVALIDO' end
    if pal_control.target_busy then return 'TARGET_SCAN_OCUPADO' end
    if type(FindObjects)~='function' or EObjectFlags==nil or EObjectFlags.RF_NoFlags==nil or EObjectFlags.RF_ClassDefaultObject==nil then
        return 'TARGET_BUSCA_INDISPONIVEL'
    end
    pal_control.target_busy=true
    local done,result=pcall(function()
        local pos=st.pal:K2_GetActorLocation()
        local rotation=st.pal:K2_GetActorRotation()
        if not pos or not rotation then return 'TARGET_ORIENTACAO_INDISPONIVEL' end
        local yr=math.rad(tonumber(rotation.Yaw) or 0)
        local fx,fy=math.cos(yr),math.sin(yr)
        -- Bounded sample, one scan only on explicit user click / TXT request.
        local actors=FindObjects(pal_control.TARGET_SCAN_LIMIT,'PalCharacter',nil,
            EObjectFlags.RF_NoFlags,EObjectFlags.RF_ClassDefaultObject,false)
        if actors==nil then return 'TARGET_SEM_CANDIDATOS' end
        local best=nil
        local n=0
        for _,actor in ipairs(actors) do
            n=n+1
            if n>pal_control.TARGET_SCAN_LIMIT then break end
            if actor~=st.pal and actor~=st.human then
              local ok,entry=pcall(function()
                local kind=pal_control.target_kind(actor)
                if kind~='PAL' and kind~='NPC' then return nil end
                local ai=actor.Controller
                if not valid(ai) or ai:HasAuthority()~=true then return nil end
                local ainame=ai:GetClass():GetFName():ToString()
                local clsname=actor:GetClass():GetFName():ToString()
                if type(ainame)~='string' or type(clsname)~='string' then return nil end
                if not cvg_pal_camera_candidate(clsname,ainame,kind=='NPC',false) then return nil end
                local ap=actor:K2_GetActorLocation()
                if not ap then return nil end
                local dx,dy,dz=ap.X-pos.X,ap.Y-pos.Y,ap.Z-pos.Z
                local distance=math.sqrt(dx*dx+dy*dy+dz*dz)
                if distance<100 or distance>pal_control.TARGET_SELECT_RADIUS_CM then return nil end
                local planar=math.sqrt(dx*dx+dy*dy)
                if planar<1 then return nil end
                local forward=(dx*fx+dy*fy)/planar
                if forward<math.cos(math.rad(pal_control.TARGET_CONE_DEG)) then return nil end
                local yawerr=math.deg(math.acos(math.max(-1,math.min(1,forward))))
                local name=clsname:gsub('[^%w_]',''):sub(1,42)
                -- Explicitly prefer centered targets, then distance; not nearest behind.
                return {actor=actor,actor_key=actor_key(actor),controller_key=actor_key(ai),
                    kind=kind,name=name,distance=distance,score=yawerr*0.7+distance/250}
              end)
              if ok and entry and entry.actor_key and entry.controller_key then
                if best==nil or entry.score<best.score then best=entry end
              end
            end
        end
        if not best then return 'TARGET_NENHUM_INIMIGO_A_FRENTE' end
        pal_control.target_lock={actor=best.actor,actor_key=best.actor_key,
            controller_key=best.controller_key,kind=best.kind,name=best.name,
            session=pal_control.mobile_session_token}
        pal_control.target_last_result='ALVO_TRAVADO'
        log('CVG_TARGET_LOCK: status=LOCKED; enemy_kind='..best.kind..'; distance_m='..math.floor(best.distance/100)..'; no_auto_shots=true; Xbox_reticle_not_accessed=true')
        return 'TARGET_LOCKED_'..best.name
    end)
    pal_control.target_busy=false
    if not done then return 'TARGET_SCAN_ERRO_LUA' end
    pal_control.target_last_result=tostring(result):sub(1,110)
    return result
end
function pal_control.target_face_before_attack(st)
    if not pal_control.target_lock then return true,'SEM_TRAVA' end
    local valid_target,info=pal_control.target_verify(st)
    if not valid_target then
        pal_control.target_clear(info)
        return false,'ALVO_PERDIDO_'..tostring(info)
    end
    -- Single yaw adjustment of the EXACT owned pawn immediately before one
    -- deliberate attack. Never rotate other players/NPCs, never touch camera.
    -- Unreal AActor::K2_SetActorRotation is documented, but Xbox outcome remains
    -- experimental. If unsupported, block rather than pretend aim assist works.
    if not pal_control.api('/Script/Engine.Actor:K2_SetActorRotation') then
        return false,'ROTACAO_NATIVA_INDISPONIVEL'
    end
    local yaw=math.deg(math.atan(info.dy,info.dx))
    if yaw~=yaw or math.abs(yaw)>180.01 then return false,'ANGULO_INVALIDO' end
    local ok,turned=pcall(function()
        local r=st.pal:K2_GetActorRotation()
        if not r then return false end
        r.Yaw=yaw
        return st.pal:K2_SetActorRotation(r,false)
    end)
    if not ok or turned~=true then return false,'GIRO_NAO_CONFIRMADO' end
    return true,'ROTACAO_HORIZ_OK'
end

function pal_control.base_attack(command)
    local function result(status,id,detail)
        local msg='CVG_BASEATTACK_RESULT: status='..status..'; pal='..tostring(id or 'UNKNOWN')
             ..'; '..tostring(detail or '')
        log(msg); return msg
    end
    if command~='BASEATTACKCHECK' and command~='BASEATTACK' then
        return result('BLOCKED','UNKNOWN','invalid_command; no_native_call=true')
    end
    local st=trial
    if not st or not st.direct_control or st.pal_lost or st.restoring or st.jump_exit_pending
      or st.offline or (st.target_kind~='PAL' and st.target_kind~='NPC') or recovery_lock~=true then
        return result('BLOCKED','UNKNOWN','no_exact_possession; no_native_call=true')
    end
    if not pal_control.exact(st,true) or not valid(st.pal) or not valid(st.pc) then
        return result('BLOCKED','UNKNOWN','owner_pawn_unverified; no_native_call=true')
    end
    local id
    if st.target_kind=='NPC' then
        -- NPC class identity is the already-tracked actor, NEVER a scan.
        id=tostring(st.pal_class or ''):sub(1,90)
        if not id:match('^BP_[%w_]+_C$') then
            return result('BLOCKED',id,'npc_class_unverified; no_native_call=true')
        end
    else
        if not pal_control.api('/Script/Pal.PalIndividualCharacterParameter:GetCharacterID') then
            return result('BLOCKED','UNKNOWN','GetCharacterID_not_reflected; no_native_call=true')
        end
        local ok,param=pcall(function()return st.pal.CharacterParameterComponent end)
        if not ok or not valid(param) then return result('BLOCKED','UNKNOWN','no_PalCharacterParameterComponent') end
        local oi,individual=pcall(function()return param:GetIndividualParameter()end)
        if not oi or not valid(individual) then return result('BLOCKED','UNKNOWN','no_individual_parameter') end
        local o,charid=pcall(function()return individual:GetCharacterID()end)
        if not o or charid==nil then return result('BLOCKED','UNKNOWN','no_PalID') end
        local converted,value=pcall(function()
            if type(charid)=='string' then return charid end
            return charid:ToString()
        end)
        if not converted or type(value)~='string' or #value>90 then
            return result('BLOCKED','UNKNOWN','pal_id_unreadable; no_native_call=true')
        end
        id=value
    end
    local candidates=pal_control.basic_candidates(id,st.target_kind)
    if #candidates==0 then return result('BLOCKED',id,'no_species_candidates; no_native_call=true') end
    local statok,stat=pcall(function()return st.pal.StaticCharacterParameterComponent end)
    if not statok or not valid(stat) then
        return result('BLOCKED',id,'no_static_character_component; no_native_call=true')
    end
    local mapok,map=pcall(function()return stat.WazaActionInstancedMap end)
    if not mapok or map==nil then
        return result('BLOCKED',id,'no_own_WazaActionInstancedMap; no_native_call=true')
    end
    local selected,cls=nil,nil
    -- Weapon_Use(362) ALWAYS checked before Human_Punch(1). If absent/unarmed,
    -- fall back to punch. Never execute both for the same button press.
    for _,candidate in ipairs(candidates) do
        local permitted=not candidate.requires_firearm or pal_control.npc_firearm_present(st)
        if permitted then
            local exists,entry=pcall(function()return map:Find(candidate.waza)end)
            if exists and entry~=nil then
                local unwrapped,klass=pcall(function()return entry:get()end)
                local found=nil
                if unwrapped and valid(klass) then found=klass
                elseif valid(entry) then found=entry end
                if valid(found) then selected=candidate;cls=found;break end
            end
        end
    end
    if not selected or not valid(cls) then
        pal_control.mobile_selected_profile=nil
        pal_control.mobile_verified_session=''
        return result('BLOCKED',id,'no_owned_basic_action_class_or_weapon; no_native_call=true')
    end
    local componentok,component=pcall(function()return st.pal.ActionComponent end)
    if not componentok or not valid(component)
      or not pal_control.api('/Script/Pal.PalActionComponent:PlayAction') then
        return result('BLOCKED',id,'own_ActionComponent_or_PlayAction_unavailable; no_native_call=true')
    end
    pal_control.mobile_selected_profile={session=pal_control.mobile_session_token,
        waza=selected.waza,skill=selected.skill,cooldown=selected.cooldown}
    if command=='BASEATTACKCHECK' then
        return result('CHECK_OK',id,'skill='..selected.skill..'; waza_id='..selected.waza
          ..'; same_actor_class=true; no_native_cast=true; xbox_result_unverified=true')
    end
    if pal_control.base_attack_busy or pal_control.native_attack_self_cast then
        return result('BLOCKED',id,'attack_in_progress; no_native_call=true')
    end
    local now=os.time()
    local cooldown=math.max(8,tonumber(selected.cooldown) or 8)
    local effective=math.max(cooldown,pal_control.base_attack_last_cooldown or 8)
    if type(now)~='number' or now-(pal_control.base_attack_last_ts or 0)<effective then
        return result('BLOCKED',id,'cooldown_seconds='..effective..'; no_native_call=true')
    end
    if trial~=st or not pal_control.exact(st,true) or st.restoring or st.pal_lost or recovery_lock~=true then
        return result('BLOCKED',id,'session_changed; no_native_call=true')
    end
    local aimok,aimreason=pal_control.target_face_before_attack(st)
    if not aimok then
        return result('BLOCKED',id,'target_lock_aim='..tostring(aimreason)..'; no_native_attack=true')
    end
    if pal_control.target_lock then
        log('CVG_TARGET_AIM: mode=OWN_PAWN_YAW_ONCE; status='..aimreason..'; no_camera_override=true; Xbox_hit_unverified=true')
    end
    pal_control.base_attack_busy=true
    pal_control.native_attack_self_cast=true
    pal_control.base_attack_last_ts=now
    pal_control.base_attack_last_cooldown=cooldown
    pal_control.base_attack_attempts=pal_control.base_attack_attempts+1
    log('CVG_BASEATTACK_PRECALL: kind='..st.target_kind..'; skill='..selected.skill
      ..'; waza_id='..selected.waza..'; single_call=true; native_crash_possible=true')
    local called,instance=pcall(function()return component:PlayAction(nil,cls)end)
    pal_control.native_attack_self_cast=false
    pal_control.base_attack_busy=false
    if not called then return result('LUA_ERROR',id,'native_PlayAction_failed; auto_retry=false') end
    return result('REQUEST_SENT',id,'waza_id='..selected.waza
       ..'; action_instance_valid='..tostring(valid(instance))
       ..'; Xbox_animation_and_damage_unverified=true')
end

local function possession_attack_check()
    if not trial or not trial.direct_control or trial.pal_lost or not pal_control.exact(trial,true) then
        return 'ATTACK_CHECK_BLOCKED: original_pal_owner_identity_unverified; no_native_call=true'
    end
    if trial.target_kind~='PAL' then
        return 'ATTACK_CHECK: NPC_attacks_not_supported; read_only=true'
    end
    local entries={}
    for index=0,2 do
        entries[#entries+1]=skill_report(skill_snapshot(trial,index))
    end
    log('ATTACK_SLOTS_READONLY: '..table.concat(entries,' | '))
    return 'ATTACK_CHECK: PlaySkill_reflected='..tostring(pal_control.api('/Script/Pal.PalPlayerController:PlaySkill'))
       ..'; 3_slots_probed=true; no_native_call=true; three_skill_commands_are_experimental=true; see_ATTACK_SLOTS_READONLY'
end

local function trial_command(action)
    if trial_op_busy then log(action..'_BUSY');return end
    trial_op_busy=true
    local ok=pcall(function()
        if type(ExecuteInGameThread)~='function' then
            log(action..'_BLOCKED: game-thread API unavailable')
            trial_op_busy=false
        else
            ExecuteInGameThread(function()
                local success=pcall(function()
                    if action=='STATUS' or action=='GHOST' or action=='CLEANUP' or action=='CONFIRM' or action=='RECOVER' then
                        reconcile_human_on_demand(action:lower())
                    end
                    if action=='STATUS' and ghost and ghost.cleanup_called then log(post_cleanup_verify()) end
                    if action=='INTERACT' then log(manual_human_interact_sync())
                    elseif action=='SPECRESUME' then log(pal_control.spec_resume_native('manual_txt'))
                    elseif action=='SPECEND' then log(pal_control.spec_end_native())
                    elseif action=='ATTACKVER' then log(pal_control.fixed_attack_command(action))
                    elseif action=='ATTACK1' then log('CVG_BASEATTACK_RESULT: status=BLOCKED; reason=legacy_ATTACK1_disabled_after_crash; no_native_call=true')
                    elseif action=='ATTACKCHECK' then log(possession_attack_check())
                    elseif action=='BASEATTACKCHECK' or action=='BASEATTACK' then pal_control.base_attack(action)
                    elseif action=='ASTRALYMSHOTCHECK' or action=='ASTRALYMSHOT' then log(pal_control.astralym_shot_341(action))
                    elseif action=='SKILLCHECK' then log(possessed_pal_skill(action))
                    elseif action=='SKILL1' or action=='SKILL2' or action=='SKILL3' then
                        log('CVG_BASEATTACK_RESULT: status=BLOCKED; reason=legacy_PlaySkill_disabled_after_crash; no_native_call=true')
                    elseif action=='PALSKILLCHECK' then
                        log('PAL_OWN_SKILLS_PROBE: '..tostring(pal_control.own_waza_command('WAZACHECK')))
                    elseif action=='PALSKILL1' or action=='PALSKILL2' or action=='PALSKILL3' then
                        log('CVG_BASEATTACK_RESULT: status=BLOCKED; reason=legacy_PALSKILL_disabled_after_crash; no_native_call=true')
                    elseif action=='PALSKILLSET1' or action=='PALSKILLSET2' or action=='PALSKILLSET3' then
                        if not trial or not trial.direct_control or trial.target_kind~='PAL'
                           or trial.pal_lost or not pal_control.exact(trial,true) then
                            log('PAL_OWN_SKILLS_SELECT_BLOCKED: exact_pal_possession_required')
                        else
                            pal_control.native_attack_selected_slot=tonumber(action:sub(-1))
                            log('PAL_OWN_SKILLS_SELECTED: slot='..tostring(pal_control.native_attack_selected_slot)
                                ..'; no_attack_called=true; equipped_Pal_skill_only=true')
                        end
                    elseif action=='WAZACHECK' or action=='WAZA1' or action=='WAZA2' or action=='WAZA3' then log('WAZA_DISABLED_v1_11_10: unsafe_skill_array_probe_not_used; use_ATTACKVER_and_ATTACK1_instead')
                    elseif action=='SAFEON' or action=='SAFEOFF' then
                        local owner,_,problem=owner_and_count()
                        if not owner then
                            log('STREAM_SAFE_BLOCKED: owner/admin not available: '..tostring(problem))
                        elseif trial or recovery_lock or ghost then
                            log('STREAM_SAFE_BLOCKED: change only while safely human and no recovery/ghost')
                        else
                            stream_safe_enabled=action=='SAFEON'
                            log('STREAM_SAFE_MODE: enabled='..tostring(stream_safe_enabled)..'; applies_to_NEXT_trial_only=true; auto_return_170m_if_enabled=true; default_off=true; no_actor_modified=true')
                        end
                    elseif action=='RESYNC' then log(resync_action())
                    elseif action=='FOCUS' then log(focus_action())
                    elseif action=='CAMARM' or action=='CAM' or action=='CAMCHECK' then log(camera_action(action))
                    elseif action=='CVGSPEC' or action=='CVGSPECEND' then log(cvg_spectate_action(action))
                    elseif action=='CAMCHECKPAL' then start_trial(true,false,true)
                    elseif action=='CAMCHECKBOSS' then start_trial(true,false,true,true)
                    elseif action=='CAMCHECKNPC' then start_trial(true,true,true)
                    elseif action=='CAMPAL' then start_trial(false,false,true)
                    elseif action=='CAMBOSS' then start_trial(false,false,true,true)
                    elseif action=='CAMNPC' then start_trial(false,true,true)
                    elseif action=='TRIAL' then start_trial(false,false,cam_baseline~=nil and cam_baseline.cvg_spectate==true)
                    elseif action=='CHECK' then start_trial(true,false,cam_baseline~=nil and cam_baseline.cvg_spectate==true)
                    elseif action=='NPCTRIAL' then start_trial(false,true,cam_baseline~=nil and cam_baseline.cvg_spectate==true)
                    elseif action=='NPCCHECK' then start_trial(true,true,cam_baseline~=nil and cam_baseline.cvg_spectate==true)
                    elseif action=='STATUS' then log(recovery_status())
                    elseif action=='GHOST' then log(ghost_status())
                    elseif action=='CLEANUP' then log('CLEANUP_DISABLED: no_player_actor_deletion_allowed')
                    elseif action=='CONFIRM' then log(confirm_recovered_human())
                    elseif action=='RECOVER' then log(recover_after_cleanup())
                    elseif action=='ENABLE' then pal_control.toggle(true)
                    elseif action=='DISABLE' then pal_control.toggle(false)
                    elseif action=='RETURN' then
                        if pal_control.handoff_pending then
                            pal_control.handoff_pending.cancelled=true
                            pal_control.handoff_pending=nil
                            log('CVG_HANDOFF_MANUAL_CANCEL: original human already verified; no native Possess')
                        else log(restore_trial('manual_request')) end
                    else log('PRIVATE_ACTION_REJECTED: unknown_command; no_native_call') end
                end)
                if not success then log(action..'_FAILED: unexpected game-thread error') end
                trial_op_busy=false
            end)
        end
    end)
    if not ok then trial_op_busy=false;log(action..'_BLOCKED: cannot schedule game thread') end
end

-- v1.10.1: Comandos pelo chat (tambem disponiveis no TXT).
-- IMPORTANTE: NUNCA ler Category nem SenderPlayerUId do FPalChatMessage nesta build.
-- A leitura de Category pode CAUSAR CRASH NATIVO no dedicated server.
-- Por isso nao e possivel garantir a origem "Guilda"; e o JOGADOR quem
-- escolhe o canal Guilda no Xbox. A autorizacao usa:
-- (a) PlayerController unico do GUID dono e bAdmin=true (multijogador permitido)
-- (b) nome textual Sender do chat == PlayerNamePrivate desse jogador.
-- Nao se confia apenas na presenca de "!cvg" no texto, nem em IP ou nickname
-- isoladamente; a comparacao precisa falhar fechada. Nunca logar nomes ou texto.
local function chat_name(s)
    if type(s)=='string' then return s:match('^%s*(.-)%s*$') end
    if s==nil then return nil end
    local ok,value=pcall(function()return s:ToString()end)
    if not ok or type(value)~='string' then return nil end
    return value:match('^%s*(.-)%s*$')
end
local function chat_authorized(sender)
    if type(sender)~='string' or #sender<1 or #sender>80 then return false,'sender_unavailable' end
    -- Requer GUID do dono e login admin, sem requisito de estar sozinho.
    local ok,pc,players,err=pcall(owner_and_count)
    if not ok or not pc then return false,'owner_admin_or_online_check_failed' end
    local ok_name,game_name=pcall(function()
        if not valid(pc.PlayerState) then return nil end
        return chat_name(pc.PlayerState.PlayerNamePrivate)
    end)
    if not ok_name or type(game_name)~='string' or game_name=='' or #game_name>80 then
        return false,'owner_player_name_unavailable'
    end
    if sender:lower()~=game_name:lower() then return false,'sender_name_not_owner' end
    -- UE4SS: comparacao Lua 'candidate ~= pc' NAO comprova UObjects distintos.
    -- Duas wrappers Lua do mesmo PlayerController nativo podem ser diferentes.
    -- Comparamos o GUID real do dono para nao bloquear o proprio jogador.
    -- O chat ainda expoe apenas Sender textual; outro jogador com nome igual
    -- continua BLOQUEADO (fail closed), inclusive se for administrador.
    local expected=owner_guid()
    if not expected then return false,'owner_guid_unavailable' end
    local unique_ok,issue=pcall(function()
        for _,candidate in ipairs(FindAllOf('PalPlayerController') or {}) do
            if valid(candidate) and candidate:HasAuthority()==true then
                local candidate_id=guid(candidate:GetPlayerUId())
                if candidate_id==nil then return 'other_player_id_unavailable' end
                if candidate_id~=expected then
                    local cs=candidate.PlayerState
                    if not valid(cs) then return 'other_player_name_unavailable' end
                    local other=chat_name(cs.PlayerNamePrivate)
                    if type(other)~='string' or other=='' then return 'other_player_name_unavailable' end
                    if other:lower()==game_name:lower() then return 'duplicate_chat_sender_name' end
                end
            end
        end
        return nil
    end)
    if not unique_ok or issue~=nil then return false,unique_ok and issue or 'other_player_scan_failed' end
    return true,nil
end

-- v1.10.0: PRE-VIABILIDADE do plano do jogador: apos sair da possessao,
-- substituir um Pal selvagem por uma instancia com IA nativa funcional.
-- NAO cria, NAO exclui, NAO aplica dano, NAO altera qualquer Pal ou save.
-- Consulta apenas METADADOS de ate 8 classes conhecidas da engine Palworld.
-- Objetivo: descobrir uma via de SPAWN SELVAGEM NATIVA antes de escrever a
-- transacao Create->Validate->Remove. UWorld:SpawnActor isolado NAO garante
-- parametrizacao do Pal nem IA selvagem. Nao implementamos clone prematuro.
local swapdiag_busy=false
local SWAPDIAG_CLASS_PATHS={
    '/Script/Pal.PalSpawner',
    '/Script/Pal.PalNPCSpawner',
    '/Script/Pal.PalSpawnerManager',
    '/Script/Pal.PalCharacterManager',
    '/Script/Pal.PalCharacter',
    '/Script/Pal.PalCheatManager',
    '/Script/Pal.PalGameStateInGame',
    '/Script/Pal.PalAIController',
}
local function swapdiag_readonly_metadata()
    if type(StaticFindObject)~='function' then
        log('SWAPDIAG_BLOCKED: StaticFindObject unavailable; no actor modified')
        return
    end
    log('SWAPDIAG_BEGIN: metadata_only=true; native_spawn_NOT_called=true; destroy_NOT_called=true; wildcard_actor_scan=false')
    local classes_available,matched_total=0,0
    for _,path in ipairs(SWAPDIAG_CLASS_PATHS) do
        local short=path:match('%.([%w_]+)$') or 'unknown'
        local got,cls=pcall(function()return StaticFindObject(path)end)
        if not got or not valid(cls) then
            log('SWAPDIAG_CLASS: '..short..'; status=UNAVAILABLE')
        else
            classes_available=classes_available+1
            local matches,scanned={},0
            local walked=pcall(function()
                cls:ForEachFunction(function(fn)
                    scanned=scanned+1
                    if scanned>650 then return true end
                    if not valid(fn) then return false end
                    local nameok,name=pcall(function()return fn:GetFName():ToString()end)
                    if not nameok or type(name)~='string' then return false end
                    local lower=name:lower()
                    if lower:find('spawn',1,true) or lower:find('respawn',1,true) or
                       lower:find('create',1,true) or lower:find('generate',1,true) or
                       lower:find('initialize',1,true) or lower:find('character',1,true) or
                       lower:find('register',1,true) or lower:find('despawn',1,true) then
                        if #matches<24 then
                            local safe=name:gsub('[^%w_]', ''):sub(1,74)
                            if #safe>0 then matches[#matches+1]=safe end
                        end
                        matched_total=matched_total+1
                    end
                    return false
                end)
            end)
            log('SWAPDIAG_CLASS: '..short..'; reflected='..tostring(walked)..
                '; scanned='..tostring(scanned)..'; first_matches='..table.concat(matches,','))
        end
    end
    log('SWAPDIAG_DONE: classes_available='..classes_available..'; matches_seen='..matched_total..
        '; metadata_only=true; no_spawns=true; no_destroys=true; no_actor_modified=true')
end
local function swapdiag_dispatch()
    if swapdiag_busy then log('SWAPDIAG_BUSY: previous reflection pending');return end
    if type(ExecuteInGameThread)~='function' then
        log('SWAPDIAG_BLOCKED: game-thread API unavailable; no_actor_modified=true')
        return
    end
    swapdiag_busy=true
    local scheduled=pcall(function()
        ExecuteInGameThread(function()
            local ok=pcall(swapdiag_readonly_metadata)
            if not ok then log('SWAPDIAG_ERROR: read-only metadata probe aborted') end
            swapdiag_busy=false
        end)
    end)
    if not scheduled then
        swapdiag_busy=false
        log('SWAPDIAG_BLOCKED: schedule failed; no actor modified')
    end
end


-- CVG BOSS MODE 1.9.16: verifica o CAMINHO REAL de spawn encontrado no
-- projeto publico dkoz/AdminCommands (spawn.lua, utils.lua), sem criar nada.
-- PalUtility:GetNPCManager(PC) e consulta nativa, nao spawn. Os membros e
-- a instancia do NPCManager sao verificados somente quando o dono pede.
-- NAO chama SpawnNPCForServer, Possess, Destroy, SetUncapturable ou dano.
-- Nao e um teste de PvE nem garante controles Xbox ou habilidades.
local bossdiag_busy=false
local function bossdiag_readonly()
    if trial or recovery_lock or ai_postcheck_pending or ai_recovery_uncertain or ghost then
        log('BOSSDIAG_BLOCKED: trial/recovery/ghost/AI uncertain; verify human and recovery; no spawn')
        return
    end
    log('BOSSDIAG_BEGIN: readonly API diagnostics only; no spawn from diagnostic; pvp_global=UNCHANGED')
    if type(StaticFindObject)~='function' then
        log('BOSSDIAG_BLOCKED: no StaticFindObject; no actor modified')
        return
    end
    local authok,pc,player_count,issue=pcall(owner_and_count)
    if not authok or not pc then
        log('BOSSDIAG_BLOCKED: owner admin verification failed; no actor modified')
        return
    end
    local pawn_ok,pawn=pcall(function()return pc:K2_GetPawn()end)
    local human_cls=pawn_ok and valid(pawn) and pawn_class_name(pawn) or nil
    if not human_cls or not human_cls:lower():find('player',1,true) then
        log('BOSSDIAG_BLOCKED: owner not in verifiable human pawn; no actor modified')
        return
    end
    log('BOSSDIAG_HUMAN_OK: human_class='..human_cls..'; original_pawn_valid=true; owner_admin=true; no controller transferred')
    local found_utility,utility=pcall(function()return StaticFindObject('/Script/Pal.Default__PalUtility')end)
    if not found_utility or not valid(utility) then
        log('BOSSDIAG_UTIL_UNAVAILABLE: PalUtility default object missing or not yet loaded; stop; no actor modified')
        return
    end
    log('BOSSDIAG_UTILITY_OK: PalUtility CDO found; owner verified')
    local manager_ok,manager=pcall(function()return utility:GetNPCManager(pc)end)
    if not manager_ok or not valid(manager) then
        log('BOSSDIAG_MANAGER_UNAVAILABLE: GetNPCManager failed/unavailable; native lookup only; no spawn')
        return
    end
    log('BOSSDIAG_MANAGER_OK: NPCManager valid; native lookup completed; no spawn')
    local ai_ok,ai_class=pcall(function()return manager.NPCAIControllerBaseClass end)
    if not ai_ok or not valid(ai_class) then
        log('BOSSDIAG_AI_UNAVAILABLE: NPCAIControllerBaseClass absent; no spawn')
        return
    end
    log('BOSSDIAG_AI_OK: manager has valid native AI controller class')
    -- Read UFunction metadata; this does not call the spawn function.
    local reflected_ok,fn=pcall(function()return StaticFindObject('/Script/Pal.PalNPCManager:SpawnNPCForServer')end)
    if reflected_ok and valid(fn) then
        log('BOSSDIAG_SPAWN_REFLECTED: SpawnNPCForServer UFunction found; NEVER_CALLED')
    else
        log('BOSSDIAG_SPAWN_UNVERIFIED: direct UFunction path not found; source-code-only hypothesis; NEVER_CALLED')
    end
    log('BOSSDIAG_DONE: world_unchanged=true; no_pal_spawned=true; no_pal_destroyed=true; next=validate_no_capture_and_pve_damage_before_unlock')
end
local function bossdiag_dispatch()
    if bossdiag_busy then log('BOSSDIAG_BUSY: another check pending'); return end
    if type(ExecuteInGameThread)~='function' then log('BOSSDIAG_BLOCKED: missing game thread; no actor modified'); return end
    bossdiag_busy=true
    local scheduled=pcall(function()
        ExecuteInGameThread(function()
            local ok=pcall(bossdiag_readonly)
            if not ok then log('BOSSDIAG_ERROR: native lookup error; no spawn requested') end
            bossdiag_busy=false
        end)
    end)
    if not scheduled then
        bossdiag_busy=false
        log('BOSSDIAG_BLOCKED: cannot schedule on game thread; no spawn')
    end
end
-- BOSS MODE v1.10.0: primeira criacao NATIVA de UM Pal temporario em laboratorio.
-- RESTRICOES: SOMENTE admin GUID+bAdmin, outros jogadores permitidos, um ativo por vez, Lv80,
-- Jetragon normal nivel 80, entrada separada; Nao tocar em Pals existentes.
-- SpawnNPCForServer vem do mod publico AdminCommands; native gameplay no
-- CVG2 nunca foi testado. Um erro NATIVO pode derrubar servidor fora do pcall.
-- Novo spawn SOMENTE apos duas confirmacoes de ausencia do ator original; nao comprova remocao integral do handle.
local boss_spawn_count=0
local boss_spawn_state=nil -- nil only after TWO verified absence checks
local boss_retired_handles={} -- exclusively our historical spawns, never scan wild actors
local boss_spawn_uncertain=false -- fail closed on ambiguous native spawn/cleanup
local boss_next_allowed_at=0
local boss_job_busy=false
local BOSS_TEST_PAL='JetDragon' -- ID interno Jetragon NORMAL (nao BOSS_JetDragon)
local BOSS_TEST_CLASS_HINT='JetDragon' -- exigir classe do Jetragon normal criado nesta sessao
local BOSS_TEST_LEVEL=80
local BOSS_LIFETIME_MS=180000
local BOSS_REARM_COOLDOWN_SEC=15
local BOSS_SECOND_POSTCHECK_MS=4000
-- v1.10.0: change ONLY the ONE Jetragon that the admin actually possesses.
-- Neither global world streaming nor players, saves, or any wild Pal are modified.
-- These actor-level replication flags may NOT fix Palworld's simulation boundary.
local BOSS_RELEVANCY_TARGET_CM=30000 -- minimum 300m when possible; AlwaysRelevant independent of this number.
local BOSS_DIAG_STEP_MS=3000 -- 3s: detects earlier than prior 10s diagnostic; finite 4min
local BOSS_DIAG_SAMPLES=80
local BOSS_AUTOSYNC_DISTANCE_CM=5500 -- once at 55m, client RPC not server restart
local function boss_pawn_safe(pc)
    local read,pawn=pcall(function()return pc:K2_GetPawn()end)
    if not read or not valid(pawn) then return nil,'human_unavailable' end
    local cls=pawn_class_name(pawn)
    if not cls or not cls:lower():find('player',1,true) then return nil,'not_human' end
    if pawn:HasAuthority()~=true or not actor_key(pawn) then return nil,'human_identity_unavailable' end
    return pawn,cls
end
local function boss_preflight()
    if trial or ghost or recovery_lock or ai_postcheck_pending or ai_recovery_uncertain then
        return nil,'recovery_or_trial_pending'
    end
    -- v1.10.0: a checagem anterior exigia type(FName)==function, mas um
    -- construtor Lua pode ser uma tabela ou userdata com __call. Verificar
    -- a construcao real, sem fazer spawn nem modificar nenhum ator.
    if type(ExecuteInGameThread)~='function' then return nil,'missing_ExecuteInGameThread' end
    if type(ExecuteWithDelay)~='function' then return nil,'missing_ExecuteWithDelay' end
    if type(StaticFindObject)~='function' then return nil,'missing_StaticFindObject' end
    if FName==nil then return nil,'missing_FName_global' end
    local name_ok,test_name=pcall(function()return FName(BOSS_TEST_PAL)end)
    if not name_ok or test_name==nil then
        return nil,'FName_constructor_failed_type_'..type(FName)
    end
    log('BOSSCHECK_API_TRACE: ExecuteInGameThread=ok; ExecuteWithDelay=ok; StaticFindObject=ok; FName_type='..type(FName)..'; FName_constructor=ok; no actor modified')
    local pc,num,why=owner_and_count()
    if not pc then return nil,'owner_not_admin' end
    if type(num)~='number' or num<1 then return nil,'owner_count_invalid' end
    local human,cls=boss_pawn_safe(pc)
    if not human then return nil,cls end
    local okloc,p=pcall(function()return human:K2_GetActorLocation()end)
    if not okloc or not p or not num_in_range(p.X,1e8) or not num_in_range(p.Y,1e8) or not num_in_range(p.Z,1e8) then
        return nil,'spawn_location_invalid'
    end
    local has_destroy,fn_destroy=pcall(function()return StaticFindObject('/Script/Engine.Actor:K2_DestroyActor')end)
    if not has_destroy or not valid(fn_destroy) then return nil,'destroy_function_unavailable' end
    local okutil,util=pcall(function()return StaticFindObject('/Script/Pal.Default__PalUtility')end)
    if not okutil or not valid(util) then return nil,'pal_utility_unavailable' end
    local okmgr,mgr=pcall(function()return util:GetNPCManager(pc)end)
    if not okmgr or not valid(mgr) then return nil,'npc_manager_unavailable' end
    local okclass,cc=pcall(function()return mgr.NPCAIControllerBaseClass end)
    if not okclass or not valid(cc) then return nil,'npc_ai_class_unavailable' end
    local pk=actor_key(pc)
    local hk=actor_key(human)
    if not pk or not hk then return nil,'owner_or_human_identity_missing' end
    return {pc=pc,human=human,human_key=hk, human_class=cls,
        pc_key=pk,players=num,npc_manager=mgr,controller_class=cc,
        test_pal_fname=test_name,
        loc={X=p.X+750,Y=p.Y,Z=p.Z+180}}
end
local function boss_cleanup(reason)
    local s=boss_spawn_state
    if not s then return 'BOSSREMOVE_IDLE: no tracked test avatar; no native call' end
    if s.cleanup_attempted then return 'BOSSREMOVE_PENDING: cleanup already requested; wait for two postchecks; no repeat destroy' end
    -- Never remove when owner is offline, swapped, or controlling the Pal.
    -- No actor in the world is eligible unless it is our exact spawn handle.
    if trial or recovery_lock then return 'BOSSREMOVE_BLOCKED: possession_or_journal_active; nothing destroyed' end
    local pc,count=owner_and_count()
    if not pc or not s.pc_key or actor_key(pc)~=s.pc_key then
        return 'BOSSREMOVE_BLOCKED: original owner/admin controller invalid; no deletion'
    end
    local ok,pawn=pcall(function()return pc:K2_GetPawn()end)
    if not ok or not pawn_matches_human(pawn,s.human_class) or
       not s.human_key or actor_key(pawn)~=s.human_key then
        return 'BOSSREMOVE_BLOCKED: exact original human not controlling current pawn; nothing destroyed'
    end
    if not valid(s.handle) then
        s.cleanup_attempted=true;boss_spawn_uncertain=true
        return 'BOSSREMOVE_UNCERTAIN: tracked native handle missing; no scan or deletion'
    end
    local get_ok,a=pcall(function()return s.handle:TryGetIndividualActor()end)
    if not get_ok or not valid(a) then
        s.cleanup_attempted=true;boss_spawn_uncertain=true
        return 'BOSSREMOVE_NO_ACTOR: original spawn handle has no active actor BEFORE cleanup; SPAWN LOCKED; inspect'
    end
    local key=actor_key(a)
    if not key or not s.actor_key or key~=s.actor_key then
        s.cleanup_attempted=true;boss_spawn_uncertain=true
        return 'BOSSREMOVE_BLOCKED: actor identity mismatch; NO deletion'
    end
    local class=pawn_class_name(a)
    if not class or not class:find(BOSS_TEST_CLASS_HINT,1,true) then
        s.cleanup_attempted=true;boss_spawn_uncertain=true
        return 'BOSSREMOVE_BLOCKED: actor class changed; NO deletion'
    end
    if s.net_original and s.net_patch_attempted then
        -- On human return, restore flags before destroying exactly this avatar.
        local revert=pcall(function()
            a.NetCullDistanceSquared=s.net_original.cull
            a.bAlwaysRelevant=s.net_original.always
        end)
        log('BOSS_NET_RESTORE: exact_temporary_actor=true; restored='..tostring(revert)..'; delete_request_follows=true')
    end
    s.cleanup_attempted=true
    -- UE AActor native function, not Palworld NPC manager lifecycle removal.
    -- This call may remove the actor but leave a handle registered; never claim full cleanup.
    local destroyed=pcall(function()a:K2_DestroyActor()end)
    if not destroyed then boss_spawn_uncertain=true;return 'BOSSREMOVE_UNCERTAIN: K2_DestroyActor Lua failure; new spawns LOCKED until next boot' end
    log('BOSSREMOVE_CALLED: reason='..reason..'; exact_spawn_actor=true; K2_DestroyActor_invoked=true; handle_cleanup_NOT_verified; no_other_actor_touched=true')
    local queued=pcall(function()
        ExecuteWithDelay(1700,function()
            local gameok=pcall(function()
                ExecuteInGameThread(function()
                    if boss_spawn_state~=s then return end
                    local h_ok,check=pcall(function()return s.handle:TryGetIndividualActor()end)
                    if not h_ok then
                        boss_spawn_uncertain=true
                        log('BOSSREMOVE_UNCERTAIN: first handle lookup ERROR; repeat spawns BLOCKED')
                        return
                    end
                    if valid(check) then
                        boss_spawn_uncertain=true
                        log('BOSSREMOVE_UNCERTAIN: actor STILL VALID after destruction; repeat spawns BLOCKED')
                        return
                    end
                    log('BOSSREMOVE_ACTOR_ABSENT: first postcheck clean; SECOND_CHECK_PENDING; full NPC handle cleanup UNVERIFIED')
                    -- A second fresh native lookup detects late reappearance and
                    -- prevents rearming from transient reference invalidation.
                    local second_scheduled=pcall(function()
                        ExecuteWithDelay(BOSS_SECOND_POSTCHECK_MS,function()
                            local second_game_ok=pcall(function()
                                ExecuteInGameThread(function()
                                    if boss_spawn_state~=s or not s.cleanup_attempted then return end
                                    if trial or recovery_lock or ghost or ai_recovery_uncertain then
                                        boss_spawn_uncertain=true
                                        log('BOSSREARM_BLOCKED: recovery/ghost/AI uncertainty; nothing spawned')
                                        return
                                    end
                                    local pc,count=owner_and_count()
                                    local pawn_ok,human=pcall(function()return pc and pc:K2_GetPawn()end)
                                    if not pc or actor_key(pc)~=s.pc_key or
                                       not pawn_ok or not pawn_matches_human(human,s.human_class) or
                                       actor_key(human)~=s.human_key then
                                        boss_spawn_uncertain=true
                                        log('BOSSREARM_BLOCKED: owner/human identity not proven; nothing spawned')
                                        return
                                    end
                                    local verify_ok,current=pcall(function()return s.handle:TryGetIndividualActor()end)
                                    if not verify_ok or valid(current) then
                                        boss_spawn_uncertain=true
                                        local found=verify_ok and valid(current)
                                        local same=found and (actor_key(current)==s.actor_key) or false
                                        local cname=found and pawn_class_name(current) or 'unavailable'
                                        log('BOSSREARM_DIAG: second_lookup_ok='..tostring(verify_ok)..'; native_actor_valid='..tostring(found)..'; same_original_actor='..tostring(same)..'; class='..tostring(cname)..'; visual_Xbox_absence_does_not_prove_handle_cleanup=true')
                                        log('BOSSREARM_BLOCKED: second actor check failed/present; NO new spawn')
                                        return
                                    end
                                    -- Actor absence is NOT complete NPCManager lifecycle cleanup.
                                    -- Retain the exact old handle and verify it before every future spawn.
                                    s.cleanup_confirmed=true
                                    boss_retired_handles[#boss_retired_handles+1]=s.handle
                                    boss_spawn_state=nil
                                    boss_next_allowed_at=os.time()+BOSS_REARM_COOLDOWN_SEC
                                    log('BOSSREARM_READY: actor_absent_twice=true; original_human_verified=true; journal_SAFE=true; cooldown_sec='..BOSS_REARM_COOLDOWN_SEC..'; retired_handles='..#boss_retired_handles..'; full_NPCManager_cleanup_UNVERIFIED; next_spawn_on_demand_only')
                                end)
                            end)
                            if not second_game_ok then boss_spawn_uncertain=true;log('BOSSREARM_BLOCKED: second game thread scheduling failed') end
                        end)
                    end)
                    if not second_scheduled then boss_spawn_uncertain=true;log('BOSSREARM_BLOCKED: second timer failed') end
                end)
            end)
            if not gameok then boss_spawn_uncertain=true;log('BOSSREMOVE_POSTCHECK_FAILED: game thread scheduling failed') end
        end)
    end)
    if not queued then boss_spawn_uncertain=true;log('BOSSREMOVE_POSTCHECK_FAILED: timer scheduling failed') end
    return 'BOSSREMOVE_PENDING: exact actor destruction requested; two read-only postchecks required before another spawn'

end
boss_cleanup_after_return=boss_cleanup
local function boss_verify_async(s,attempt)
    if boss_spawn_state~=s or s.cleanup_attempted then return end
    if not valid(s.handle) then
        boss_spawn_uncertain=true;log('BOSSSPAWN_FAILED: own native handle became invalid; repeats LOCKED')
        return
    end
    local pa_ok,param=pcall(function()return s.handle:TryGetIndividualParameter()end)
    local ac_ok,actor=pcall(function()return s.handle:TryGetIndividualActor()end)
    if not ac_ok or not valid(actor) or not pa_ok or not valid(param) then
        if attempt>=8 then
            boss_spawn_uncertain=true;log('BOSSSPAWN_UNVERIFIED: native actor/parameter did not materialize in 8 checks; no Possess; repeats LOCKED')
            return
        end
        ExecuteWithDelay(250,function()
            local ok=pcall(function()ExecuteInGameThread(function()boss_verify_async(s,attempt+1)end)end)
            if not ok then log('BOSSSPAWN_UNVERIFIED: delayed game thread dispatch unavailable') end
        end)
        return
    end
    local akey=actor_key(actor)
    local cls=pawn_class_name(actor)
    if not akey or not cls or not cls:find(BOSS_TEST_CLASS_HINT,1,true) then
        boss_spawn_uncertain=true;log('BOSSSPAWN_BLOCKED: spawned actor class/identity does not match JetDragon normal; repeats LOCKED; inspect UE4SS log')
        return
    end
    s.actor_key=akey
    s.actor=actor
    -- Two independent flags from publicly available Palworld AdminCommands.
    -- This is still NOT proof capture is impossible in live game.
    local pset=pcall(function()param.bIsUncapturable=true end)
    local comp_ok,comp=pcall(function()return actor.StaticCharacterParameterComponent end)
    local cset=comp_ok and valid(comp) and pcall(function()comp.IsUncapturable=true end) or false
    local rp,pp=pcall(function()return param.bIsUncapturable end)
    local rc,cc=pcall(function()return comp.IsUncapturable end)
    s.no_capture_flags=(pset and cset and rp and pp==true and rc and cc==true)
    local locok,actor_loc=pcall(function()return actor:K2_GetActorLocation()end)
    local pos='unavailable'
    if locok and actor_loc and num_in_range(actor_loc.X,1e8) and num_in_range(actor_loc.Y,1e8) and num_in_range(actor_loc.Z,1e8) then
        pos=string.format('%.0f,%.0f,%.0f',actor_loc.X,actor_loc.Y,actor_loc.Z)
    end
    log('BOSSSPAWN_ACTOR_READY: species='..BOSS_TEST_PAL..'; level_requested='..BOSS_TEST_LEVEL..'; exact_handle=true; class='..cls..'; actor_xyz_cm='..pos..'; no_capture_flags='..tostring(s.no_capture_flags)..'; capture_immunity_NOT_verified; Xbox_visibility_NOT_verified; Xbox_BossEnter=EXPERIMENTAL_SEPARATE_COMMAND')
    if not s.no_capture_flags then
        log('BOSSSPAWN_CAPTURE_GUARD_FAILED: unable to prove both capture flags; attempting cleanup of own test actor')
        log(boss_cleanup('capture_guard_failed'))
    end
end
local function boss_spawn_test()
    if boss_spawn_uncertain then return 'BOSSSPAWN_BLOCKED: previous native lifecycle uncertain; restart NOT automatic; operator review' end
    if boss_spawn_state then return 'BOSSSPAWN_BLOCKED: previous avatar still active or postchecks pending; BOSSVERIFY' end
    if os.time()<boss_next_allowed_at then return 'BOSSSPAWN_BLOCKED: cooldown after verified cleanup; retry later' end
    -- Before each spawn confirm ALL earlier handles still have no actor.
    for _,old in ipairs(boss_retired_handles) do
        if not valid(old) then
            boss_spawn_uncertain=true
            return 'BOSSSPAWN_BLOCKED: previous handle invalid/unverifiable; stop repeat tests'
        end
        local checkok,actor=pcall(function()return old:TryGetIndividualActor()end)
        if not checkok or valid(actor) then
            boss_spawn_uncertain=true
            return 'BOSSSPAWN_BLOCKED: previous retired avatar actor reappeared/lookup failed; no spawn'
        end
    end
    local p,reason=boss_preflight()
    if not p then return 'BOSSSPAWN_BLOCKED: '..reason..'; no actor touched' end
    boss_spawn_count=boss_spawn_count+1 -- native attempt number; one active only
    local info={ControllerClass=p.controller_class,CharacterID=p.test_pal_fname,
        Level=BOSS_TEST_LEVEL,Location=p.loc,Yaw=0.0,Squad=nil}
    log('BOSSSPAWN_REQUESTED: attempt='..boss_spawn_count..'; owner_admin_confirmed=true; players_online='..tostring(p.players)..'; others_untouched=true; level='..BOSS_TEST_LEVEL..'; species='..BOSS_TEST_PAL..'; spawn_xyz_cm='..string.format('%.0f,%.0f,%.0f',p.loc.X,p.loc.Y,p.loc.Z)..'; offset_from_human_cm=+750X,+0Y,+180Z; client_visibility_UNVERIFIED=true; no_global_PvP_changes=true; no_combat_test=true; do_not_capture=true')
    local ok,handle=pcall(function()return p.npc_manager:SpawnNPCForServer(info,nil)end)
    if not ok or not valid(handle) then
        boss_spawn_uncertain=true
        return 'BOSSSPAWN_FAILED: native function returned error/invalid handle; further spawns locked for safety'
    end
    local s={handle=handle,human_key=p.human_key,human_class=p.human_class,pc_key=p.pc_key,cleanup_attempted=false,created_at=os.time(),enter_attempted=false,spawn_attempt=boss_spawn_count}
    boss_spawn_state=s
    log('BOSSSPAWN_HANDLE_OK: unique new native handle tracked in RAM; actor not yet proven; no existing Pals scanned or modified')
    local ready=pcall(function()
        ExecuteWithDelay(250,function()
            local go=pcall(function()ExecuteInGameThread(function()boss_verify_async(s,1)end)end)
            if not go then log('BOSSSPAWN_VERIFY_UNAVAILABLE: cannot schedule game thread') end
        end)
        ExecuteWithDelay(BOSS_LIFETIME_MS,function()
            local go=pcall(function()ExecuteInGameThread(function()if boss_spawn_state==s then
                    if trial and trial.temporary_boss==true and trial.pal_key==s.actor_key then
                        log('BOSSLIFETIME_DEFERRED: owner actively controls tracked temporary Jetragon; do not destroy controlled Pawn; wait for VERIFIED human return; Android TXT RETURN available')
                    else
                        log(boss_cleanup('auto_3min'))
                    end
                end end)end)
            if not go then log('BOSSREMOVE_AUTO_UNAVAILABLE: delayed dispatch failed; manual BOSSREMOVE required') end
        end)
    end)
    if not ready then
        boss_spawn_uncertain=true
        log('BOSSSPAWN_TIMER_FAILED: own temporary actor created but timer failed; use BOSSREMOVE immediately; future spawns BLOCKED')
        return 'BOSSSPAWN_TIMER_FAILED: no automatic cleanup guarantee; manual removal required'
    end
    return 'BOSSSPAWN_STARTED: native Pal spawn requested; unpossessed avatar auto-removal attempted after 3min; possessed avatar stays until MANUAL verified return; do NOT capture'
end
-- 1.9.15 manual exit ONLY. Keep rescue TXT; DO NOT test combat yet.
-- Admin owner can be online with others, but must use same original human pawn.
-- One possession attempt PER UNIQUE AVATAR; NO forced time return.
-- RETURN via TXT Android, chat, or 3 Xbox jumps. No disconnect watchdog.
local function boss_enter_onepal()
    if not CVG_NATIVE_POSSESSION_ENABLED then
        return 'CVG_PROTECTED_BOSSENTER_BLOCKED: native Possess disabled; no actor modified'
    end
    local s=boss_spawn_state
    if s and s.enter_attempted then return 'BOSSENTER_BLOCKED: one possess attempt per avatar; spawn next only after verified removal' end
    if not s or s.cleanup_attempted or not s.no_capture_flags then
        return 'BOSSENTER_BLOCKED: no live tracked actor with both capture flags; no Possess'
    end
    if not jump_hook_installed or not death_hook_installed or not capture_hook_installed then
        return 'BOSSENTER_BLOCKED: missing jump/death/capture hook; no Possess'
    end
    local p,why=boss_preflight()
    if not p then return 'BOSSENTER_BLOCKED: '..why..'; no Possess' end
    if p.pc_key~=s.pc_key or p.human_key~=s.human_key or p.human_class~=s.human_class then
        return 'BOSSENTER_BLOCKED: player human identity changed since spawn; no Possess'
    end
    if type(os.time())~='number' or not s.created_at or os.time()-s.created_at>70 then
        return 'BOSSENTER_BLOCKED: spawn older than 70 seconds; 3-minute deletion timer too close'
    end
    local okactor,a=pcall(function()return s.handle:TryGetIndividualActor()end)
    if not okactor or not valid(a) or not s.actor_key or actor_key(a)~=s.actor_key or
       pawn_class_name(a)==nil or not pawn_class_name(a):find(BOSS_TEST_CLASS_HINT,1,true) or
       a:HasAuthority()~=true then
        return 'BOSSENTER_BLOCKED: spawned actor missing/changed/not authoritative; no Possess'
    end
    local okp,param=pcall(function()return s.handle:TryGetIndividualParameter()end)
    local okc,comp=pcall(function()return a.StaticCharacterParameterComponent end)
    local cap_ok,cap1,cap2=pcall(function()return param.bIsUncapturable==true,comp.IsUncapturable==true end)
    if not okp or not valid(param) or not okc or not valid(comp) or not cap_ok or cap1~=true or cap2~=true then
        return 'BOSSENTER_BLOCKED: capture flags lost; no Possess'
    end
    -- Capture the original replication flags BEFORE Possess. Never modify an existing Wild Pal.
    local netok,netbase=pcall(function()
        local always=a.bAlwaysRelevant
        local cull=a.NetCullDistanceSquared
        if type(always)~='boolean' or type(cull)~='number' or cull~=cull or cull<0 or cull>1e15 then return nil end
        return {always=always,cull=cull}
    end)
    if not netok or not netbase then
        return 'BOSSENTER_BLOCKED: TEMP Jetragon network flags not readable; NO Possess, no risky write'
    end
    log(string.format('BOSS_NET_BASELINE: own_avatar=true; original_always=%s; original_cull_m=%.1f; target_cull_m=300; no_writes_yet=true',tostring(netbase.always),math.sqrt(netbase.cull)/100))
    -- Do not let the automatic 3min removal destroy a pawn under active control.
    if not recovery_journal_write(true,s.human_class) then
        return 'BOSSENTER_BLOCKED: persistent ACTIVE journal unavailable; no Possess'
    end
    s.enter_attempted=true -- BEFORE native call; no retry on same native actor
    recovery_lock=true;recovery_class=s.human_class
    trial={temporary_boss=true,pc=p.pc,pc_key=p.pc_key,human=p.human,human_key=p.human_key,
        human_class=p.human_class,pal=a,pal_key=s.actor_key,pal_class=pawn_class_name(a),
        jump_times={},controlled=false,restoring=false,pal_lost=false,offline=false,
        restore_attempts=0,reconnect_attempts=0,emergency_pending=false,
        emergency_attempted=false,jump_exit_pending=false,resync_attempted=false}
    log('BOSSENTER_CALL: original_human_persisted=true; owner_admin_only=true; additional_players_permitted=true; unique_temp_actor=true; original_wild_pal_untouched=true; forced_timer=OFF; return=MANUAL_ANDROID_CHAT_OR_3_JUMPS; NO_PVE_DAMAGE_TEST')
    local did=pcall(function()p.pc:Possess(a)end)
    if not did then
        return 'BOSSENTER_NATIVE_ERROR: '..restore_trial('temporary_boss_possess_error')
    end
    local got,current=pcall(function()return p.pc:K2_GetPawn()end)
    if not got or not valid(current) or actor_key(current)~=s.actor_key then
        log('BOSSENTER_UNVERIFIED: native pawn transfer not proven; guarded RETURN immediately')
        return 'BOSSENTER_UNVERIFIED: '..restore_trial('temporary_boss_unverified')
    end
    if not trial then return 'BOSSENTER_UNVERIFIED: trial disappeared unexpectedly; inspect' end
    trial.controlled=true
    -- The server confirmed that the ORIGINAL admin controller now possesses the
    -- EXACT temporary Jetragon. Apply relevancy only after that confirmation.
    -- No client camera, remote world streaming, or native player class is modified.
    local state=trial
    state.range_original=netbase
    state.range_applied=true -- restore best-effort even if a partial property write occurs
    s.net_original=netbase
    s.net_patch_attempted=true
    local target=math.max(netbase.cull,BOSS_RELEVANCY_TARGET_CM*BOSS_RELEVANCY_TARGET_CM)
    local wrote=pcall(function()
        a.NetCullDistanceSquared=target
        a.bAlwaysRelevant=true
    end)
    local checked,now_cull,now_always=pcall(function()
        return a.NetCullDistanceSquared,a.bAlwaysRelevant
    end)
    if not wrote or not checked or now_always~=true or type(now_cull)~='number' or now_cull<target then
        log('BOSS_NET_PATCH_FAILED: exact spawned avatar did not confirm flags; guarded immediate human return; no remote streaming change')
        return 'BOSSENTER_NET_FAILED: '..restore_trial('boss_network_patch_failed')
    end
    local pushed=pcall(function()a:ForceNetUpdate()end)
    log('BOSS_NET_PATCH_APPLIED: exact_owned_temporary_Jetragon=true; bAlwaysRelevant=true; NetCullDistanceSquared_min_m=300; ForceNetUpdate_invoked='..tostring(pushed)..'; this_does_NOT_prove_Xbox_distance_fixed=true; no_other_actors_changed=true')
    -- Read-only, bounded server telemetry helps distinguish Xbox freeze from
    -- actual native actor stop. No full-world scans, no actor mutation.
    local function boss_sample(step)
        if step>BOSS_DIAG_SAMPLES or type(ExecuteWithDelay)~='function' then return end
        local queued=pcall(function()ExecuteWithDelay(BOSS_DIAG_STEP_MS,function()
            local go=pcall(function()ExecuteInGameThread(function()
                if trial~=state or state.restoring or not valid(state.pal) or not valid(state.human) then return end
                local owner_ok,pcpawn=pcall(function()return state.pc:K2_GetPawn()end)
                if not owner_ok or not valid(pcpawn) or actor_key(pcpawn)~=state.pal_key then
                    log('BOSS_DISTANCE_STOPPED: original owner no longer controls tracked avatar; no automatic recovery attempted')
                    return
                end
                local hloc=cam_geo(state.human)
                local ploc=cam_geo(state.pal)
                local dist=(hloc and ploc and cam_delta(hloc,ploc) or nil)
                local ve_ok,v=pcall(function()return state.pal:GetVelocity()end)
                local speed='unavailable'
                if ve_ok and v and num_in_range(v.X,1e6) and num_in_range(v.Y,1e6) and num_in_range(v.Z,1e6) then
                    speed=string.format('%.1f',math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z))
                end
                local view_ok,view=pcall(function()return state.pc:GetViewTarget()end)
                local vt='unavailable'
                if view_ok and valid(view) then
                    local k=actor_key(view)
                    vt=k==state.pal_key and 'pal' or (k==state.human_key and 'human' or 'other')
                end
                -- Different from actor relevancy: a stale PlayerController focal location
                -- can keep the Xbox's notion of local world centred on the old human.
                -- Read-only comparison; no global streaming or human movement.
                local focal_text='unavailable'
                local foc_ok,foc=pcall(function()return state.pc:GetFocalLocation()end)
                if foc_ok and foc and ploc and num_in_range(foc.X,1e8) and num_in_range(foc.Y,1e8) and num_in_range(foc.Z,1e8) then
                    local fdist=cam_delta({x=foc.X,y=foc.Y,z=foc.Z},ploc)
                    if fdist then focal_text=string.format('%.1f',fdist/100) end
                end
                if step==1 or step%3==0 or (dist and dist>=BOSS_AUTOSYNC_DISTANCE_CM and not state.auto_resync_requested) then
                    log('BOSS_DISTANCE_SAMPLE: step='..step..'; pal_to_human_m='..(dist and string.format('%.1f',dist/100) or 'unavailable')..'; pc_focal_to_pal_m='..focal_text..'; pal_speed_cm_s='..speed..'; server_view_target='..vt..'; client_camera_UNVERIFIED=true; relevancy_boost=true; read_only=true')
                end
                -- Single authenticated native RPC that was already present as a
                -- manual experiment. Trigger before the long-distance freeze.
                -- It does NOT teleport the human, spawn another actor or restart CVG2.
                if dist and dist>=BOSS_AUTOSYNC_DISTANCE_CM and not state.auto_resync_requested and not state.resync_attempted then
                    local ownerpc,count=owner_and_count()
                    if ownerpc and actor_key(ownerpc)==state.pc_key then
                        state.auto_resync_requested=true
                        log('BOSS_CLIENTSYNC_AUTO_REQUESTED: distance_m='..string.format('%.1f',dist/100)..'; one_attempt=true; client_restart_only=true; user_human_not_moved=true')
                        trial_command('RESYNC')
                    else
                        log('BOSS_CLIENTSYNC_AUTO_SKIPPED: original owner/admin controller mismatch; no RPC')
                    end
                end
                boss_sample(step+1)
            end)end)
            if not go then log('BOSS_DISTANCE_STOPPED: game thread unavailable') end
        end)end)
        if not queued then log('BOSS_DISTANCE_STOPPED: timer unavailable') end
    end
    boss_sample(1)
    log('BOSSENTER_MANUAL_RETURN_ARMED: no possess duration timer; Android TXT RETURN with new sequence is primary emergency exit; 3 jumps/chat are alternatives; only own actor is eligible for later cleanup')
    return 'BOSSENTER_CONTROLLED: exact temporary Jetragon normal LV80; NET_RELEVANCY_PLUS_AUTO_CLIENT_RESTART_AT_55M; NO_AUTO_RETURN_TIMER; exit manually with TXT RETURN / 3 jumps / chat; NO COMBAT; NO CAPTURE'

end
local function boss_verify_onepal()
    local s=boss_spawn_state
    if not s then
        if boss_spawn_uncertain then return 'BOSSVERIFY_LOCKED: prior lifecycle uncertain; no further spawn' end
        return 'BOSSVERIFY_READY: no active avatar; previous_attempts='..boss_spawn_count..'; retired_handles='..#boss_retired_handles..'; cooldown_remaining_sec='..math.max(0,boss_next_allowed_at-os.time())..'; actor absent verified twice on cleanup; full NPCManager cleanup UNVERIFIED'
    end
    if not valid(s.handle) then return 'BOSSVERIFY_HANDLE_INVALID: NPC lifecycle unknown; no actors touched' end
    local ok,a=pcall(function()return s.handle:TryGetIndividualActor()end)
    if not ok or not valid(a) then
        return 'BOSSVERIFY_ACTOR_ABSENT: actor no longer accessible; handle cleanup UNVERIFIED; no actors touched'
    end
    local key=actor_key(a)
    if not key or not s.actor_key or key~=s.actor_key then
        return 'BOSSVERIFY_IDENTITY_CHANGED: cannot prove original spawn; no actors touched'
    end
    local destroyed_ok,destroyed=pcall(function()return a.bActorIsBeingDestroyed==true end)
    return 'BOSSVERIFY_ACTOR_PRESENT: own original actor still visible to handle; cleanup_called='..tostring(s.cleanup_attempted==true)..'; destroying='..tostring(destroyed_ok and destroyed==true)..'; no actors touched'
end

local function boss_command(action)
    if boss_job_busy then log('BOSS_JOB_BUSY');return end
    if type(ExecuteInGameThread)~='function' then log('BOSS_BLOCKED: game thread unavailable');return end
    boss_job_busy=true
    local ok=pcall(function()ExecuteInGameThread(function()
        local worked,result=pcall(function()
            if action=='BOSSCHECK' then
                local p,why=boss_preflight()
                if p then return 'BOSSCHECK_OK: owner/admin verified+human+NPCManager+DestroyFunction available; players_online='..tostring(p.players)..'; multiplayer_allowed=true; native spawning still risky; no actor modified'
                else return 'BOSSCHECK_BLOCKED: '..why..'; no actor modified' end
            elseif action=='BOSSSPAWN' then return boss_spawn_test()
            elseif action=='BOSSREMOVE' then return boss_cleanup('manual_request')
            elseif action=='BOSSENTER' then return boss_enter_onepal()
            elseif action=='BOSSVERIFY' then return boss_verify_onepal()
            end
            return 'BOSS_UNKNOWN_ACTION'
        end)
        if worked then log(result) else log('BOSS_COMMAND_ERROR: native Lua command error; do not repeat without review')end
        boss_job_busy=false
    end)end)
    if not ok then boss_job_busy=false;log('BOSS_COMMAND_BLOCKED: game-thread dispatch failed')end
end

local function boss_mode_status()
    log('BOSSMODE_STATUS: stage=JETDRAGON_CLIENT_RESTART_55M_OWNER_MULTIPLAYER; attempts='..boss_spawn_count..'; one_active_at_a_time=true; rearm_locked='..tostring(boss_spawn_uncertain)..'; active_or_pending='..tostring(boss_spawn_state~=nil)..'; retired='..#boss_retired_handles..'; owner_only_commands=true; solo_required=false; pve_damage_UNVERIFIED=true; full_NPC_lifecycle_UNVERIFIED=true; global_pvp_UNCHANGED=true')
end

local function on_chat(_, parameter)
    -- v1.10.1: habilitado; nenhuma mutacao sem nome unico do admin/owner.
    -- O UID do evento do chat NAO e lido nesta build (risco nativo).
    -- Nao logar conteudo nem nome do jogador.
    seen=seen+1
    if seen<=8 then log('CHAT_HOOK_SEEN: callback='..seen..'; no content logged') end
    -- Somente FString Sender e Message sao lidos. Categoria de Guilda NAO e lida.
    local ok,sender,value=pcall(function()
        if parameter==nil then return nil,nil end
        local s=parameter:get()
        if s==nil then return nil,nil end
        return chat_name(s.Sender),chat_name(s.Message)
    end)
    if not ok or type(value)~='string' then
        if seen<=8 then log('CHAT_PAYLOAD_UNREADABLE: text or sender decoding failed') end
        return
    end
    decoded=decoded+1
    if decoded<=8 then log('CHAT_PAYLOAD_OK: message decoded; text redacted') end
    local normalized=value:lower():match('^%s*(.-)%s*$')
    if normalized=='!cvgdiag' or normalized=='cvgdiag' then
        log('CHAT_DIAG_RECEIVED: diagnostic marker; no game actor touched')
        return
    end
    local action=normalized:match('^!cvg%s+([a-z0-9]+)$')
    -- Alias curtos para uso no Xbox ANTES da posse. Mantem todos os gates
    -- de autenticacao e de 30min do NPCTRIAL original; nao cria bypass.
    if action=='npc' or action=='humano' then action='npctrial' end
    if action=='espectar' or action=='spectate' or action=='cameras' then action='cvgspec' end
    if action=='sairespectar' or action=='sairspec' then action='cvgspecend' end
    if action=='npcver' or action=='humanover' then action='npccheck' end
    if action=='interacao' or action=='interagir' then action='interact' end
    if action~='ping' and action~='help' and action~='attackcheck' and action~='interact' and action~='skillcheck' and action~='skill1' and action~='skill2' and action~='skill3' and action~='attackver' and action~='attack1' and action~='wazacheck' and action~='waza1' and action~='waza2' and action~='waza3' and action~='trial' and action~='check' and action~='npccheck' and action~='npctrial' and action~='return' and action~='status' and action~='confirm' and action~='ghost' and action~='cleanup' and action~='recover' and action~='jump' and action~='safety' and action~='cvgspec' and action~='cvgspecend' and action~='camarm' and action~='cam' and action~='camcheck' and action~='camcheckpal' and action~='camchecknpc' and action~='campal' and action~='camboss' and action~='camnpc' and action~='range' and action~='rangeon' and action~='rangeoff' and action~='swapdiag' and action~='bossdiag' and action~='boss' and action~='bosscheck' and action~='bossspawn' and action~='bossremove' and action~='bossenter' and action~='bossverify' and action~='msgtest' and action~='focus' and action~='esquivaon' and action~='esquivaoff' and action~='esquivaver' then return end
    -- Mesmo prefixo de outro usuario OU mensagem de sistema: NAO executar.
    local auth_call,allowed,reason=pcall(chat_authorized,sender)
    if not auth_call then
        log('CHAT_AUTH_BLOCKED: authorization runtime failed; no_actor_modified=true')
        return
    end
    if not allowed then
        log('CHAT_AUTH_BLOCKED: '..tostring(reason)..'; no_actor_modified=true')
        return
    end
    local now=os.time()
    if type(now)~='number' then
        log('CHAT_COMMAND_IGNORED: clock_unavailable; no_actor_modified=true')
        return
    end
    if action~='trial' and action~='npctrial' and action~='campal' and action~='camnpc' and action~='cvgspec' and action==last_chat_action and last_chat_action_ts and now-last_chat_action_ts<3 then
        log('CHAT_COMMAND_DUPLICATE_IGNORED: debounced; no_actor_modified=true')
        return
    end
    last_chat_action,last_chat_action_ts=action,now
    if action=='esquivaon' then
        pal_control.dodge_command('DODGEARM')
    elseif action=='esquivaoff' then
        pal_control.dodge_command('DODGEDISARM')
    elseif action=='esquivaver' then
        pal_control.dodge_command('DODGESTATUS')
    elseif action=='help' then
        log('CHAT_HELP: !cvg esquivaon/esquivaoff/esquivaver (experimental); dodge BP link needs owner exact; 3 jumps RETURN; !cvg interact (reenvia RPC de interacao para humano apos retorno), !cvg ping (30min), espectar to start native spectate, cam to read server RPC, cvgspecend to exit, camcheckpal/camcheckboss/camchecknpc, campal/camboss/camnpc (manual), npcver/npc/trial, return; TXT fallback; no automatic camera possession')
    elseif action=='msgtest' then
        log('MSGTEST_OK: authenticated admin requested one private in-game notice; no actor modified; Xbox_delivery_NOT_verified')
    elseif action=='ping' then
        chat_armed=true
        chat_armed_until=now+CHAT_ARM_TTL_SECONDS
        log('CHAT_PING_OK: owner/admin/name_unique; armed_30min=true; other_players_permitted=true; CHAT_SENDER_UID_UNREADABLE_BY_DESIGN; guild_channel_unverified=true; no_actor_modified=true')
    elseif action=='range' or action=='rangeon' or action=='rangeoff' then
        if action=='range' then
            log('RANGE_MODE_STATUS: boost_200m='..tostring(range_boost_enabled)..'; only_new_trial=true; 40min_backup=true; use !cvg rangeon/rangeoff; no actor modified')
        elseif trial or recovery_lock or ghost then
            log('RANGE_MODE_BLOCKED: trial/ghost/recovery pending; verify human before change')
        elseif action=='rangeon' then
            range_boost_enabled=true
            log('RANGE_MODE_ON: experiment armed for next TRIAL; one Pal only; 200m relevancy; native property risk')
        else
            range_boost_enabled=false
            log('RANGE_MODE_OFF: experiment disabled for next TRIAL; no actor modified')
        end
    elseif action=='swapdiag' then
        swapdiag_dispatch()
    elseif action=='bossdiag' then
        bossdiag_dispatch()
    elseif action=='boss' then
        boss_mode_status()
    elseif action=='bosscheck' or action=='bossspawn' or action=='bossremove' or action=='bossenter' or action=='bossverify' then
        boss_command(action:upper())
    elseif action=='safety' then
        log('PAL_SAFETY_DIAG: death_hook='..tostring(death_hook_installed)..'; capture_hook='..tostring(capture_hook_installed)..'; no_polling=true; no_native_rescue_guarantee=true')
    elseif action=='cvgspec' or action=='cvgspecend' then
        -- AUTORIZACAO por dono/admin/nome unico ja foi exigida acima.
        -- PING deixa de ser uma trava para iniciar a camera.
        trial_command(action:upper())
    elseif action=='camarm' or action=='cam' or action=='camcheck' or action=='camcheckpal' or action=='camcheckboss' or action=='camchecknpc' then
        trial_command(action:upper())
    elseif action=='jump' then
        if jump_hook_installed then log('JUMP_DIAG_READY: OnJumped native hook installed, Xbox Pal event delivery unverified; no actor modified')
        else log('JUMP_DIAG_UNAVAILABLE: OnJumped hook could not be registered; use TXT RETURN; no actor modified') end
    elseif action=='attackcheck' then
        trial_command('ATTACKCHECK')
    elseif action=='interact' then
        trial_command('INTERACT')
    elseif action=='attackver' or action=='attack1' then
        -- Xbox chat pode nao estar disponivel na possessao; use TXT privado.
        trial_command(action:upper())
    elseif action=='wazacheck' or action=='waza1' or action=='waza2' or action=='waza3' then
        if action~='wazacheck' and (not chat_armed or now>chat_armed_until) then
            log('CHAT_WAZA_BLOCKED: skill requires !cvg ping arm; no_native_call=true');return
        end
        log('CHAT_WAZA_COMMAND: owner/admin verified; actor_waza_path_experimental=true')
        trial_command(action:upper())
    elseif action=='skillcheck' or action=='skill1' or action=='skill2' or action=='skill3' then
        if action~='skillcheck' and (not chat_armed or now>chat_armed_until) then
            log('CHAT_COMMAND_BLOCKED: skill requires !cvg ping (30min arm); no_actor_modified=true')
            return
        end
        log('CHAT_SKILL_REQUESTED: owner/admin authorized; experimental_native_skill=true; Xbox_input_not_mapped=true')
        trial_command(action:upper())
    elseif action=='check' or action=='npccheck' then
        log((action=='npccheck' and 'NPC_CHAT_CHECK_REQUESTED' or 'CHAT_PREFLIGHT_REQUESTED')..': owner/admin verified; no possession or spawn')
        trial_command(action:upper()=='CHECK' and 'CHECK' or 'NPCCHECK')
    elseif action=='trial' or action=='npctrial' or action=='campal' or action=='camboss' or action=='camnpc' then
        -- Sem renovacao obrigatoria de PING para cada sessao/reteste;
        -- chat_authorized(sender) continua autenticando unico owner/admin.
        log((action=='npctrial' and 'NPC_CHAT_TRIAL_REQUESTED' or 'CHAT_TRIAL_REQUESTED')..': owner/admin/sender_name_unique; other_players_permitted=true; same_native_prechecks')
        trial_command(action:upper()=='TRIAL' and 'TRIAL' or (action=='campal' and 'CAMPAL' or (action=='camboss' and 'CAMBOSS' or (action=='camnpc' and 'CAMNPC' or 'NPCTRIAL'))))
    elseif action=='return' then
        -- RETURN emergencial pode funcionar mesmo sem ping anterior.
        log('CHAT_RETURN_REQUESTED: owner/admin/sender verified; restoring if active')
        trial_command('RETURN')
    elseif action=='status' then
        trial_command('STATUS')
    elseif action=='focus' then
        trial_command('FOCUS')
    elseif action=='ghost' then
        trial_command('GHOST')
    elseif action=='recover' then
        trial_command('RECOVER')
    elseif action=='cleanup' then
        if not chat_armed then log('CHAT_COMMAND_BLOCKED: chat not armed by !cvg ping');return end
        log('CHAT_GHOST_CLEANUP_REQUESTED: authenticated owner; requires prior ghost inspection and native checks')
        trial_command('CLEANUP')
    elseif action=='confirm' then
        -- Confirm only checks original player class; never invokes Possess.
        trial_command('CONFIRM')
    end
end
-- Pure string encoding: status file contains no user IDs, tokens or secret credentials.
function pal_control.mobile_jsonstr(v)
    v=tostring(v or ''):sub(1,160)
    return '"'..v:gsub('\\','\\\\'):gsub('"','\\"'):gsub('[\n\r\t]',' ')..'"'
end
function pal_control.mobile_class_species(c,kind)
    c=tostring(c or '')
    local klass=c:match('^BP_(.-)_C$') or c
    if kind=='NPC' then
        local human_id=klass:gsub('[^%w_]',''):sub(1,45)
        return 'NPC humano ('..human_id..')',klass
    end
    if klass:find('WorldTreeDragon',1,true) then return 'Astralym',klass end
    local bare=klass:gsub('^BOSS_',''):gsub('^GYM_','')
    local catalog=pal_control.basic_species_catalog[klass] or pal_control.basic_species_catalog[bare]
    local name=(catalog and catalog[1]) or pal_control.mobile_display_by_class[bare] or bare
    if type(name)~='string' or #name<1 or #name>100 then name='Pal desconhecido' end
    return name,klass
end
function pal_control.mobile_update_state(force)
    local s=trial
    -- Reflection checks are already part of the existing monitor; avoid extra
    -- GetEquipWaza/WazaActionInstancedMap/PlaySkill and never touch actor names.
    local active=s~=nil and s.direct_control==true and (s.target_kind=='PAL' or s.target_kind=='NPC')
        and s.restoring~=true and s.pal_lost~=true and s.offline~=true
        and s.jump_exit_pending~=true and recovery_lock==true
        and pal_control.exact(s,true)==true
    if active and pal_control.mobile_tracked_trial~=s then
        pal_control.mobile_session_serial=pal_control.mobile_session_serial+1
        pal_control.mobile_session_token=tostring(os.time())..string.format('%04d',pal_control.mobile_session_serial%10000)
        pal_control.mobile_armed_token=''
        pal_control.mobile_verified_session=''
        pal_control.mobile_selected_profile=nil
        pal_control.target_clear('NOVA_POSSE')
        pal_control.mobile_last_result='NEW_POSSESSION'
        pal_control.mobile_tracked_trial=s
    elseif not active and pal_control.mobile_tracked_trial~=nil then
        pal_control.mobile_tracked_trial=nil
        pal_control.mobile_session_token=''
        pal_control.mobile_armed_token=''
        pal_control.mobile_verified_session=''
        pal_control.mobile_selected_profile=nil
        pal_control.target_clear('SEM_POSSE')
        pal_control.mobile_last_result='NO_POSSESSION'
    end
    local name,kind='',''
    local skill,waza,cooldown='',0,8
    local supported=false
    if active then
        name,kind=pal_control.mobile_class_species(s.pal_class,s.target_kind)
        local candidates=pal_control.basic_candidates(kind,s.target_kind)
        local selected=candidates[1]
        local last=pal_control.mobile_selected_profile
        if last and last.session==pal_control.mobile_session_token then selected=last end
        if selected then
            skill=selected.skill or ''
            waza=tonumber(selected.waza) or 0
            cooldown=math.max(8,tonumber(selected.cooldown) or 8)
        end
        supported=#candidates>0 -- candidate != confirmed cast; MOBILECHECK must pass
    end
    local armed=active and pal_control.mobile_armed_token==pal_control.mobile_session_token
    local allowed=active and supported
    local locked=false
    local target_name,target_distance='-',0
    if active and pal_control.target_lock then
        local ok,info=pal_control.target_verify(s)
        if ok then
            locked=true
            target_name=info.name
            target_distance=math.floor(info.distance/100)
        else
            pal_control.target_clear(info)
        end
    end
    local state='{'..'"schema":1,"active":'..tostring(active)
        ..',"pal_name":'..pal_control.mobile_jsonstr(name)..',"pal_class":'..pal_control.mobile_jsonstr(active and s.pal_class or '')
        ..',"skill_name":'..pal_control.mobile_jsonstr(skill)..',"waza_id":'..tostring(waza)
        ..',"cooldown_seconds":'..tostring(cooldown)
        ..',"session":'..pal_control.mobile_jsonstr(active and pal_control.mobile_session_token or '')
        ..',"armed":'..tostring(armed)..',"attack_supported":'..tostring(allowed)
        ..',"target_locked":'..tostring(locked)..',"target_name":'..pal_control.mobile_jsonstr(target_name)
        ..',"target_distance_m":'..tostring(target_distance)
        ..',"last_sequence":'..tostring(pal_control.last_sequence or 0)
        ..',"last_result":'..pal_control.mobile_jsonstr(pal_control.mobile_last_result)
        ..',"updated_unix":'..tostring(os.time())..'}'
    local now=os.time()
    -- Only one small file write on change / every 4 seconds (no high-rate I/O).
    if not force and pal_control.mobile_last_state_signature==state and now-pal_control.mobile_state_last_write<4 then return end
    pal_control.mobile_state_last_write=now
    pal_control.mobile_last_state_signature=state
    local ok=pcall(function()
        local f=io.open(pal_control.MOBILE_STATE_FILE,'w')
        if not f then error('status_file_unavailable') end
        f:write(state)
        f:close()
    end)
    if ok and not pal_control.mobile_status_first_write_seen then
        pal_control.mobile_status_first_write_seen=true
        log('CVG_MOBILE_STATUS_WRITE_OK: state_file='..tostring(pal_control.MOBILE_STATE_FILE)..'; first_write=true; no_private_user_data=true')
    end
    if not ok and not pal_control.mobile_io_warned then
        pal_control.mobile_io_warned=true
        log('CVG_MOBILE_STATUS_IO_ERROR: writing_status_file_failed; no_actor_modified=true')
    end
end


function pal_control.mobile_handle_command(action,seq,token)
    local number=tonumber(seq)
    if not number or number<1 or #seq>8 or number<=pal_control.last_sequence then
        log('CVG_MOBILE_COMMAND_BLOCKED: invalid_or_old_sequence; no_native_call=true');return
    end
    pal_control.last_sequence=number
    -- Check ownership/session again ON THE GAME THREAD before doing any action.
    local ok=pcall(function() ExecuteInGameThread(function()
        local s=trial
        local good=s~=nil and s.direct_control==true and (s.target_kind=='PAL' or s.target_kind=='NPC')
            and not s.restoring and not s.pal_lost and recovery_lock==true
            and pal_control.mobile_tracked_trial==s and token==pal_control.mobile_session_token
            and pal_control.exact(s,true)==true
        if not good then
            pal_control.mobile_last_result='BLOCKED_STALE_SESSION';pal_control.mobile_update_state(true)
            log('CVG_MOBILE_COMMAND_BLOCKED: wrong_or_stale_session; no_native_call=true');return
        end
        if action=='MOBILEARM' then
            if pal_control.mobile_verified_session~=token then
                pal_control.mobile_last_result='BLOCKED_NEEDS_MOBILECHECK'
                pal_control.mobile_update_state(true);return
            end
            pal_control.mobile_armed_token=token
            pal_control.mobile_last_result='ARMED_EXPERIMENTAL';pal_control.mobile_update_state(true)
        elseif action=='MOBILEDISARM' then
            pal_control.mobile_armed_token='';pal_control.mobile_last_result='DISARMED';pal_control.mobile_update_state(true)
        elseif action=='MOBILECHECK' then
            -- Read-only: verify same pawn and its own firearm(362) or punch(1) action.
            local success,res=pcall(function()return pal_control.base_attack('BASEATTACKCHECK')end)
            if success and type(res)=='string' and res:find('status=CHECK_OK',1,true) then
                pal_control.mobile_verified_session=token
            else
                pal_control.mobile_verified_session=''
                pal_control.mobile_armed_token=''
            end
            pal_control.mobile_last_result=(success and tostring(res) or 'CHECK_LUA_ERROR'):sub(1,155)
            pal_control.mobile_update_state(true)
        elseif action=='MOBILEATTACK' then
            if pal_control.mobile_armed_token~=token or pal_control.mobile_verified_session~=token then
                pal_control.mobile_last_result='BLOCKED_NOT_ARMED'; pal_control.mobile_update_state(true);return
            end
            -- One native PlayAction only, no retry; this can crash even inside pcall.
            local success,res=pcall(function()return pal_control.base_attack('BASEATTACK')end)
            pal_control.mobile_last_result=(success and tostring(res) or 'ATTACK_LUA_ERROR'):sub(1,155)
            pal_control.mobile_update_state(true)
        elseif action=='MOBILETARGETLOCK' or action=='MOBILETARGETCLEAR' then
            local cmd=action=='MOBILETARGETLOCK' and 'TARGETLOCK' or 'TARGETCLEAR'
            pal_control.mobile_last_result=pal_control.target_action(cmd)
            pal_control.mobile_update_state(true)
        elseif action=='MOBILERETURN' then
            pal_control.mobile_armed_token='';pal_control.mobile_last_result='RETURN_REQUESTED';pal_control.mobile_update_state(true)
            trial_command('RETURN')
        end
    end) end)
    if not ok then log('CVG_MOBILE_COMMAND_BLOCKED: no_game_thread; no_native_call=true') end
end
local function read_request()
    local f=io.open(REQUEST_FILE,'r')
    if not f then return nil end
    local contents=f:read(160)
    f:close()
    return contents
end
local function handle_request(command)
    if command == nil then return end
    if last_request==nil then
        last_request=command
        log('PRIVATE_FILE_READY: initial content ignored; edit file to a new request')
        return
    end
    if command==last_request then return end
    last_request=command
    -- Nao registrar texto recebido de arquivo em claro (pode conter segredo).
    if type(command)~='string' or #command>80 then
        log('PRIVATE_FILE_IGNORED: invalid length');return
    end
    -- Mobile requests are bound to the exact possession token; old UI cannot attack new Pal.
    local m_action,m_seq,m_token=command:upper():match('^%s*(MOBILE%u+)%s+(%d+)%s+(%d+)%s*$')
    if m_action then
        if m_action~='MOBILEARM' and m_action~='MOBILEDISARM'
           and m_action~='MOBILECHECK' and m_action~='MOBILEATTACK'
           and m_action~='MOBILERETURN' and m_action~='MOBILETARGETLOCK'
           and m_action~='MOBILETARGETCLEAR' then
            log('CVG_MOBILE_COMMAND_BLOCKED: unknown_command');return
        end
        pal_control.mobile_handle_command(m_action,m_seq,m_token)
        return
    end
    local action, seq=command:upper():match('^%s*(PING)%s+(%d+)%s*$')
    if not action then action,seq=command:upper():match('^%s*(ADMIN)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(VIEW)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(AIM)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(ORIGIN)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(NEAR)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(CVGSPEC)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(CVGSPECEND)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(SPECRESUME)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(SPECEND)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(CAMARM)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(CAMCHECK)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(CAMCHECKPAL)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(CAMCHECKNPC)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(CAMPAL)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(CAMNPC)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(CAM)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(FOCUS)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(RESYNC)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(SAFEON)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(SAFEOFF)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(TRIAL)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(CHECK)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(RETURN)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(STATUS)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(CONFIRM)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(GHOST)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(CLEANUP)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(RECOVER)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(SWAPDIAG)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(BOSSDIAG)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(BOSSCHECK)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(BOSSSPAWN)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(BOSSREMOVE)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(BOSSENTER)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(BOSSVERIFY)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(BOSS)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(DODGEARM)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(DODGEDISARM)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(DODGESTATUS)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(RTARM)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(RTDISARM)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(RTSTATUS)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(NOTICEON)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(NOTICEOFF)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(NOTICESTATUS)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(MSGTEST)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(ENABLE)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(DISABLE)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(INTERACT)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(TARGETLOCK)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(TARGETCLEAR)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(TARGETSTATUS)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(BASEATTACKCHECK)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(BASEATTACK)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(PALSKILLCHECK)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(PALSKILLSET[123])%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(PALSKILL[123])%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(ASTRALYMSHOTCHECK)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(ASTRALYMSHOT)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(SKILLCHECK)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(ATTACKCHECK)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(SKILL1)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(SKILL2)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(SKILL3)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(ATTACKVER)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(ATTACK1)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(WAZACHECK)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(WAZA1)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(WAZA2)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(WAZA3)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(NPCVER)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(NPC)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(NPCCHECK)%s+(%d+)%s*$') end
    if not action then action,seq=command:upper():match('^%s*(NPCTRIAL)%s+(%d+)%s*$') end
    if not action or #seq>8 then
        log('PRIVATE_FILE_IGNORED: use PALSKILLCHECK/PALSKILL1-3/PALSKILLSET1-3 or ASTRALYMSHOTCHECK/ASTRALYMSHOT or PING/ADMIN/VIEW/AIM/ORIGIN/NEAR/CVGSPEC/CVGSPECEND/CAMARM/CAM/CAMCHECK/CAMCHECKPAL/CAMCHECKNPC/CAMPAL/CAMNPC/FOCUS/RESYNC/SAFEON/SAFEOFF/CHECK/TRIAL/NPCVER/NPC/NPCCHECK/NPCTRIAL/INTERACT/SKILLCHECK/SKILL1/SKILL2/SKILL3/WAZACHECK/WAZA1/WAZA2/WAZA3/ATTACKVER/ATTACK1/ENABLE/DISABLE/RETURN/STATUS/CONFIRM/GHOST/SWAPDIAG/BOSSDIAG/BOSS/BOSSCHECK/BOSSSPAWN/BOSSREMOVE/BOSSENTER/BOSSVERIFY/MSGTEST plus a new number');return
    end
    local request_number=tonumber(seq)
    if not request_number or request_number<1 or request_number<=pal_control.last_sequence then
        log('PRIVATE_FILE_IGNORED: use_a_strictly_increasing_positive_number; no_native_call');return
    end
    pal_control.last_sequence=request_number
    if action=='TARGETLOCK' or action=='TARGETCLEAR' or action=='TARGETSTATUS' then
        local scheduled=pcall(function()ExecuteInGameThread(function()
            local res=pal_control.target_action(action)
            log('CVG_TARGET_COMMAND: result='..tostring(res):sub(1,100))
            pal_control.mobile_last_result=res
            pal_control.mobile_update_state(true)
        end)end)
        if not scheduled then log('CVG_TARGET_COMMAND: game_thread_unavailable') end
        return
    end
    if action=='NOTICEOFF' then
        pal_control.private_result_notices=false
        log('CVG_PRIVATE_NOTICE_DISABLED: all_native_owner_messages_off=true');return
    end
    if action=='NOTICEON' then
        pal_control.private_result_notices=true
        log('CVG_PRIVATE_NOTICE_ENABLED: selective_result_only=true; native_risk_remains=true');return
    end
    if action=='NOTICESTATUS' then
        log('CVG_PRIVATE_NOTICE_STATUS: enabled='..tostring(pal_control.private_result_notices));return
    end
    if action=='DODGEARM' or action=='DODGEDISARM' or action=='DODGESTATUS' then
        pal_control.dodge_command(action);return
    end
    if action=='RTSTATUS' then
        log('CVG_RT_STATUS: hooked='..tostring(pal_control.rt_hook_count or 0)
            ..'; armed='..tostring(pal_control.rt_auto_armed==true)
            ..'; profile_auto_allowed='..tostring(pal_control.rt_auto_profile==true)
            ..'; private_results='..tostring(pal_control.private_result_notices)
            ..'; attempts='..tostring(pal_control.rt_cast_count or 0)
            ..'; unlimited_attempts_same_session=true; per_press=true; cooldown_seconds=8'
            ..'; eligible_session_events='..tostring(pal_control.rt_seen or 0)
            ..'; raw_shoot='..tostring((pal_control.rt_raw or {}).SHOOT or 0)
            ..'; raw_aim='..tostring((pal_control.rt_raw or {}).AIM or 0)
            ..'; raw_alt='..tostring((pal_control.rt_raw or {}).ALT or 0)
            ..'; raw_action='..tostring((pal_control.rt_raw or {}).ACTION or 0)
            ..'; raw_counts_include_other_players=true; Xbox_RT_not_yet_proven=true');return
    end
    if action=='RTDISARM' then
        pal_control.rt_auto_armed=false;pal_control.rt_pressed=false;pal_control.rt_armed_trial=nil
        log('CVG_RT_DISARMED: auto_skill_off=true; native_manual_skill_unchanged=true');return
    end
    if action=='RTARM' then
        local t=trial
        if pal_control.rt_auto_profile~=true then
            log('CVG_RT_ARM_BLOCKED: diagnostic_profile_only; no_auto_attacks=true');return
        end
        if not t or t.target_kind~='PAL' or not t.direct_control or t.pal_lost or t.restoring
           or not pal_control.exact(t,true) or recovery_lock~=true then
            log('CVG_RT_ARM_BLOCKED: verified_owned_pal_session_required');return
        end
        pal_control.rt_auto_armed=true;pal_control.rt_pressed=false;pal_control.rt_armed_trial=t
        log('CVG_RT_ARMED: clone_only=true; exact_pal_shooter_required=true; unlimited_attempts_same_session=true; one_attack_per_new_press=true; cooldown=8s; no_native_auto_loop=true; Xbox_RT_mapping_unproven=true');return
    end
    if action=='NPC' then action='NPCTRIAL' end
    if action=='NPCVER' then action='NPCCHECK' end
    if action=='BASEATTACK' or action=='BASEATTACKCHECK' or action=='PALSKILLCHECK' or action:match('^PALSKILL[123]$') or action:match('^PALSKILLSET[123]$') or action=='ASTRALYMSHOTCHECK' or action=='ASTRALYMSHOT' or action=='ENABLE' or action=='DISABLE' or action=='NPCCHECK' or action=='NPCTRIAL' or action=='SKILLCHECK' or action=='SKILL1' or action=='SKILL2' or action=='SKILL3' or action=='ATTACKVER' or action=='ATTACK1' or action=='WAZACHECK' or action=='WAZA1' or action=='WAZA2' or action=='WAZA3' then trial_command(action);return end
    if action=='PING' then
        log('PRIVATE_PING_OK: server-side file trigger received; no game actor touched')
    elseif action=='ADMIN' then
        if admin_busy then log('ADMIN_CHECK_BUSY');return end
        admin_busy=true
        local ok,err=pcall(function()
            if type(ExecuteInGameThread)~='function' then
                log('ADMIN_CHECK_BLOCKED: game-thread API unavailable')
                admin_busy=false
            else
                ExecuteInGameThread(function()
                    local success=pcall(admin_diagnostic)
                    if not success then log('ADMIN_CHECK_FAILED: unexpected error') end
                    admin_busy=false
                end)
            end
        end)
        if not ok then admin_busy=false;log('ADMIN_CHECK_BLOCKED: unable to schedule game thread') end
    elseif action=='SWAPDIAG' then
        swapdiag_dispatch()
    elseif action=='BOSSDIAG' then
        bossdiag_dispatch()
    elseif action=='BOSS' then
        boss_mode_status()
    elseif action=='BOSSCHECK' or action=='BOSSSPAWN' or action=='BOSSREMOVE' or action=='BOSSENTER' or action=='BOSSVERIFY' then
        boss_command(action)
    elseif action=='VIEW' then
        if view_busy then log('VIEW_BUSY');return end
        view_busy=true
        local ok=pcall(function()
            if type(ExecuteInGameThread)~='function' then
                log('VIEW_BLOCKED: game-thread API unavailable')
                view_busy=false
            else
                ExecuteInGameThread(function()
                    local success=pcall(view_diagnostic)
                    if not success then log('VIEW_FAILED: unexpected diagnostic error') end
                    view_busy=false
                end)
            end
        end)
        if not ok then view_busy=false;log('VIEW_BLOCKED: unable to schedule game thread') end
    elseif action=='MSGTEST' then
        if type(ExecuteInGameThread)~='function' then
            log('MSGTEST_BLOCKED: game thread missing')
        else
            local scheduled=pcall(function()
                ExecuteInGameThread(function() log('MSGTEST_OK: attempting private message to owner; no actor modified; Xbox delivery unverified') end)
            end)
            if not scheduled then log('MSGTEST_BLOCKED: cannot schedule game thread') end
        end
    elseif action=='TRIAL' or action=='CHECK' or action=='RETURN' or action=='STATUS' or action=='CONFIRM' or action=='GHOST' or action=='CLEANUP' or action=='RECOVER' or action=='CVGSPEC' or action=='CVGSPECEND' or action=='SPECRESUME' or action=='SPECEND' or action=='CAMARM' or action=='CAM' or action=='CAMCHECK' or action=='CAMCHECKPAL' or action=='CAMCHECKNPC' or action=='CAMCHECKBOSS' or action=='CAMPAL' or action=='CAMBOSS' or action=='CAMNPC' or action=='FOCUS' or action=='RESYNC' or action=='SAFEON' or action=='SAFEOFF' or action=='ATTACKCHECK' or action=='INTERACT' then
        trial_command(action)
    elseif action=='NEAR' then
        if near_busy then log('NEAR_BUSY');return end
        near_busy=true
        local ok=pcall(function()
            if type(ExecuteInGameThread)~='function' then
                log('NEAR_BLOCKED: game-thread API unavailable')
                near_busy=false
            else
                ExecuteInGameThread(function()
                    local worked=pcall(near_diagnostic)
                    if not worked then log('NEAR_FAILED: unexpected diagnostic error') end
                    near_busy=false
                end)
            end
        end)
        if not ok then near_busy=false;log('NEAR_BLOCKED: unable to schedule game thread') end
    elseif action=='AIM' or action=='ORIGIN' then
        local busy=(action=='AIM' and aim_busy) or (action=='ORIGIN' and origin_busy)
        if busy then log(action..'_BUSY');return end
        if action=='AIM' then aim_busy=true else origin_busy=true end
        local function release()
            if action=='AIM' then aim_busy=false else origin_busy=false end
        end
        local ok=pcall(function()
            if type(ExecuteInGameThread)~='function' then
                log(action..'_BLOCKED: game-thread API unavailable')
                release()
            else
                ExecuteInGameThread(function()
                    local success=pcall(function() aim_or_origin_diagnostic(action) end)
                    if not success then log(action..'_FAILED: unexpected diagnostic error') end
                    release()
                end)
            end
        end)
        if not ok then release();log(action..'_BLOCKED: unable to schedule game thread') end
    end
end


-- CVG v1.11.11.8 — ponte entre a ACAO DE JOGO e Paldium Shot.
-- Nao le o RT, nao altera input do Xbox, nao instala DLL, nao modifica gameplay fora do Pal do admin.
-- NAO assume que PlayAction seja acionado pelo ataque normal; essa hipotese e registrada.
-- PlayAction pode refletir animacoes nao-ofensivas. Perfil AUTO exige classe com nome de combate.
pal_control.native_attack_auto_enabled=false
pal_control.native_attack_self_cast=false
pal_control.native_attack_busy=false
pal_control.native_attack_last_ts=nil
pal_control.native_attack_seen=0
pal_control.native_attack_observed_attacks=0
pal_control.native_attack_hook_installed=false
pal_control.native_attack_cooldown_seconds=8
pal_control.native_attack_selected_slot=1
pal_control.own_skill_manual_enabled=false

function pal_control.native_class_name_safe(value)
    if not valid(value) then return nil end
    local ok,name=pcall(function() return value:GetFName():ToString() end)
    if ok and type(name)=='string' and #name>0 and #name<180 then return name end
    return nil
end

function pal_control.native_game_action_hook(ctx, target_arg, class_arg)
    if pal_control.native_attack_self_cast or not pal_control.native_attack_hook_installed then return end
    local s=trial
    if not s or not s.direct_control or s.target_kind~='PAL' or s.pal_lost or s.restoring
        or s.jump_exit_pending or recovery_lock~=true then return end
    -- Cross-check the same originally possessed Pal (the only authorized game actor).
    if not pal_control.exact(s,true) then return end
    local ok_comp,comp=pcall(function()return ctx and ctx:get()end)
    if not ok_comp or not valid(comp) then return end
    local ok_own,own_comp=pcall(function()return s.pal.ActionComponent end)
    if not ok_own or not valid(own_comp) or actor_key(comp)~=actor_key(own_comp) then return end
    -- This is NOT Xbox button data. Only the class of an action already executing on the server.
    local ok_cls,cls=pcall(function()return class_arg and class_arg:get()end)
    local cname=(ok_cls and pal_control.native_class_name_safe(cls)) or 'UNKNOWN'
    local lower=cname:lower()
    local attack_likely = lower:find('attack',1,true) ~= nil
        or lower:find('shoot',1,true) ~= nil
        or lower:find('skill',1,true) ~= nil
        or lower:find('waza',1,true) ~= nil
        or lower:find('melee',1,true) ~= nil
        or lower:find('punch',1,true) ~= nil
    pal_control.native_attack_seen=pal_control.native_attack_seen+1
    if pal_control.native_attack_seen<=32 then
        log('GAME_ACTION_OBSERVED: exact_owned_pal=true; action_class='..cname
           ..'; possible_combat='..tostring(attack_likely)
           ..'; observed='..tostring(pal_control.native_attack_seen)
           ..'; auto='..tostring(pal_control.native_attack_auto_enabled))
    end
    if not attack_likely then return end
    pal_control.native_attack_observed_attacks=pal_control.native_attack_observed_attacks+1
    if pal_control.native_attack_observed_attacks<=32 then
        log('GAME_ATTACK_CANDIDATE: class='..cname..'; not_yet_proven_to_match_Xbox_attack=true')
    end
    if not pal_control.native_attack_auto_enabled then return end
    if pal_control.native_attack_busy or type(ExecuteWithDelay)~='function' or type(ExecuteInGameThread)~='function' then return end
    local now=os.time()
    if type(now)~='number' or (pal_control.native_attack_last_ts and
        now-pal_control.native_attack_last_ts<pal_control.native_attack_cooldown_seconds) then return end
    pal_control.native_attack_busy=true
    pal_control.native_attack_last_ts=now
    log('PAL_OWN_SKILL_AUTO_QUEUED: native_action_observed=true; slot='..tostring(pal_control.native_attack_selected_slot)..'; id_comes_from_owned_Pal=true; Xbox_attack_unverified=true')
    local queued=pcall(function() ExecuteWithDelay(250,function()
        local submitted=pcall(function() ExecuteInGameThread(function()
            local ok,result=pcall(function()
                if trial~=s or not pal_control.exact(s,true) or s.restoring or s.pal_lost or
                   recovery_lock~=true then return 'GAME_ATTACK_ABORT: possession_changed' end
                return pal_control.own_waza_command('WAZA'..tostring(pal_control.native_attack_selected_slot or 1))
            end)
            if ok then log('PAL_OWN_SKILL_AUTO_RESULT: '..tostring(result))
            else log('PAL_OWN_SKILL_AUTO_LUA_ERROR: no_retry=true') end
            pal_control.native_attack_busy=false
        end) end)
        if not submitted then
            pal_control.native_attack_busy=false
            log('PAL_OWN_SKILL_AUTO_ABORT: no_game_thread_execution; no_cast=true')
        end
    end) end)
    if not queued then
        pal_control.native_attack_busy=false
        log('PAL_OWN_SKILL_AUTO_ABORT: no_delay_schedule; no_cast=true')
    end
end


-- CVG v1.11.11.12. Entradas Server indicadas no catalogo do Work (05/11/2026).
-- O catalogo NAO comprova que o Xbox envie esses RPCs DURANTE possessao.
-- Todos os hooks sao passivos por padrao. AUTO somente no perfil clone, apos RTARM.
-- RTARM habilita varias tentativas na MESMA posse ate RTDISARM/RETURN.
-- Somente borda pressionar-soltar; cooldown de 8s e uma chamada nativa por pressao.
-- NAO ha auto-loop, nem bypass de identidade, nem garantia de mapping do RT Xbox.
pal_control.rt_auto_profile=false -- RT so diagnostico; esquiva tem seu proprio caminho, sem disparo duplo
pal_control.rt_auto_armed=false
pal_control.rt_pressed=false
pal_control.rt_armed_trial=nil
pal_control.rt_hook_count=0
pal_control.rt_raw={SHOOT=0,AIM=0,ALT=0,ACTION=0}
pal_control.rt_seen=0
pal_control.rt_cast_count=0
pal_control.rt_cast_busy=false
pal_control.rt_last_ts=0
pal_control.rt_last_rpc_log_ts=0
pal_control.rt_shooter_identity='UNKNOWN'

function pal_control.rt_arg(arg)
    if arg==nil then return nil end
    local ty=type(arg)
    if ty=='boolean' or ty=='number' or ty=='string' then return arg end
    local ok,val=pcall(function()return arg:get()end)
    if ok then return val end
    return nil
end
function pal_control.rt_boolean(arg)
    local val=pal_control.rt_arg(arg)
    if type(val)=='boolean' then return val end
    return nil -- no adivinhamos booleano em ABI nao comprovada
end
function pal_control.rt_pc_guard(ctx)
    local sess=trial
    if not sess or sess.target_kind~='PAL' or sess.restoring or sess.pal_lost
       or not sess.direct_control or recovery_lock~=true then return nil end
    local pc=pal_control.rt_arg(ctx)
    if not valid(pc) or not sess.pc_key or actor_key(pc)~=sess.pc_key then return nil end
    if not pal_control.exact(sess,true) then return nil end
    return sess
end
function pal_control.rt_shooter_kind(sess,arg)
    local shooter=pal_control.rt_arg(arg)
    if not valid(shooter) then return 'UNREADABLE' end
    local pal=valid(sess.pal) and sess.pal or nil
    local human=valid(sess.human) and sess.human or nil
    -- Suporte a uma propriedade de ShooterComponent em diferentes construcoes.
    for _,pair in ipairs({{'PAL',pal},{'HUMAN',human}}) do
        local obj=pair[2]
        if valid(obj) then
            local ok,member=pcall(function()return obj.ShooterComponent end)
            if ok and valid(member) and actor_key(member)==actor_key(shooter) then return pair[1] end
        end
    end
    local ok,owner=pcall(function()return shooter:GetOwner()end)
    if ok and valid(owner) then
        local key=actor_key(owner)
        if key and key==sess.pal_key then return 'PAL' end
        if key and key==sess.human_key then return 'HUMAN' end
    end
    return 'OTHER_OR_UNKNOWN'
end
function pal_control.rt_observe(source,ctx,arg1,arg2,arg3,arg4)
    pal_control.rt_raw[source]=(pal_control.rt_raw[source] or 0)+1
    local sess=pal_control.rt_pc_guard(ctx)
    if not sess then return end
    local signal_arg=arg3
    if source=='AIM' then signal_arg=arg4 end
    local state=pal_control.rt_boolean(signal_arg)
    local kind=pal_control.rt_shooter_kind(sess,arg1)
    local should_log=pal_control.rt_seen<60
    pal_control.rt_seen=pal_control.rt_seen+1
    if should_log then
        log('CVG_INPUT_EVENT: rpc='..source..'; controller=AUTHENTICATED_ADMIN; shooter='..kind
            ..'; state='..tostring(state)..'; session=PAL; auto_armed='..tostring(pal_control.rt_auto_armed)
            ..'; none_of_these_values_prove_physical_RT=true')
    end
    if source~='SHOOT' then return end
    if state==false then pal_control.rt_pressed=false;return end
    if state~=true or pal_control.rt_pressed then return end
    pal_control.rt_pressed=true
    if not pal_control.rt_auto_profile or not pal_control.rt_auto_armed then return end
    if sess~=pal_control.rt_armed_trial then
        log('CVG_RT_AUTO_BLOCKED: armed_session_mismatch; no_cast=true');return
    end
    if kind~='PAL' then
        log('CVG_RT_AUTO_BLOCKED: shooter_not_verified_as_same_possessed_pal; kind='..kind);return
    end
    if pal_control.rt_cast_busy or type(ExecuteInGameThread)~='function' or type(ExecuteWithDelay)~='function' then return end
    local now=os.time()
    if type(now)~='number' or now-(pal_control.rt_last_ts or 0)<8 then return end
    pal_control.rt_last_ts=now
    pal_control.rt_cast_busy=true
    -- Nao desarmar apos ataque: repetir somente quando soltar/pressionar RT de novo.
    -- A sessao mantem a identidade exata ate RETURN ou RTDISARM.
    pal_control.rt_cast_count=pal_control.rt_cast_count+1
    local queued=pcall(function()ExecuteWithDelay(250,function()
        local ok=pcall(function()ExecuteInGameThread(function()
            if trial~=sess or not pal_control.rt_auto_profile
               or not pal_control.exact(sess,true) or sess.pal_lost or sess.restoring
               or recovery_lock~=true then
                log('CVG_BASEATTACK_RESULT: status=BLOCKED; reason=RT_session_changed_or_returned; no_native_call=true')
            else
                -- Auto RT exige identidade EXATA e especie predefinida; nunca usa slot.
                local succeeded,res=pcall(function()return pal_control.base_attack('BASEATTACK')end)
                -- Erro Lua de ataque nativo exige rearmar manualmente; nao repetir em erro.
                if not succeeded or (type(res)=='string' and res:find('status=LUA_ERROR',1,true)) then
                    pal_control.rt_auto_armed=false
                    pal_control.rt_armed_trial=nil
                    if not succeeded then log('CVG_BASEATTACK_RESULT: status=LUA_ERROR; reason=RT_automatic_Lua_failure; RT_disarmed_for_safety=true') end
                end
            end
            pal_control.rt_cast_busy=false
        end)end)
        if not ok then pal_control.rt_cast_busy=false end
    end)end)
    if not queued then pal_control.rt_cast_busy=false end
end
function pal_control.rt_action_observe(ctx,target,dyn,action_class,issuer)
    pal_control.rt_raw.ACTION=(pal_control.rt_raw.ACTION or 0)+1
    local sess=pal_control.rt_pc_guard(ctx)
    if not sess then return end
    pal_control.rt_seen=pal_control.rt_seen+1
    if pal_control.rt_seen>60 then return end
    local cls=pal_control.rt_arg(action_class)
    local name=pal_control.native_class_name_safe(cls) or 'UNREADABLE'
    -- O alvo de PlayAction pode ser um INIMIGO, nao o atacante; nunca servir como autorizacao.
    log('CVG_INPUT_EVENT: rpc=ACTION_SERVER; controller=AUTHENTICATED_ADMIN; class='..name
        ..'; action_target_untrusted=true; auto_from_action_rpc=false; Xbox_mapping_unverified=true')
    -- Somente nome EXATO da classe de esquiva. Um RPC qualquer NAO e uma esquiva.
    local exact_name=name:match('([%w_]+)$')
    if exact_name and pal_control.dodge_rpc_classes and pal_control.dodge_rpc_classes[exact_name] then
        pal_control.dodge_rpc_candidates=pal_control.dodge_rpc_candidates+1
        log('CVG_DODGE_RPC_EVENT: authenticated_owner_controller=true; class='..exact_name
            ..'; candidate_action_roll=true; source_Pal_vs_Human_not_proven=true')
        -- Observacao somente: RPC alvo e ambíguo. Autoriza ataque exclusivamente
        -- se o hook BP tiver confirmado o exato Pal da sessao.
    end
end
-- CVG ESQUIVA: evento BP documentado em 2026, entrega no dedicated Xbox nao confirmada.
-- Nota de arquitetura: o pequeno movimento da camera NAO e input autenticado.
-- Ao menos uma rota precisa identificar EXATAMENTE o owner do Pal (BP hook) ou
-- o PlayerController autenticado com classe rolling EXATA (RPC server).
pal_control.dodge_bp_path='/Game/Pal/Blueprint/Action/Common/BP_ActionStep_New_Rolling.BP_ActionStep_New_Rolling_C:OnBeginAction'
pal_control.dodge_rpc_classes={
    BP_ActionStep_New_Rolling_C=true,
    BP_Action_Rolling_C=true,
}
function pal_control.dodge_status()
    local active=pal_control.dodge_armed==true and trial~=nil
        and pal_control.dodge_armed_session==trial
    log('CVG_DODGE_STATUS: hook_installed='..tostring(pal_control.dodge_hook_installed)
        ..'; hook_attempts='..tostring(pal_control.dodge_hook_attempts)
        ..'; armed_current_session='..tostring(active)
        ..'; raw_bp_events_all_players='..tostring(pal_control.dodge_hook_events)
        ..'; own_pal_bp_events='..tostring(pal_control.dodge_owner_events)
        ..'; unresolved_bp_events='..tostring(pal_control.dodge_unresolved_events)
        ..'; authenticated_rolling_rpc_events='..tostring(pal_control.dodge_rpc_candidates)
        ..'; attack_requests='..tostring(pal_control.dodge_attack_calls)
        ..'; native_dodge_delivery_Xbox_unverified=true; returns_three_jumps_unchanged=true')
end
function pal_control.dodge_command(action)
    if action=='DODGESTATUS' then pal_control.dodge_status();return end
    if action=='DODGEDISARM' then
        pal_control.dodge_armed=false
        pal_control.dodge_armed_session=nil
        -- Pendente agendado verifica armamento e sessao novamente antes de chamar skill.
        log('CVG_DODGE_DISARMED: session_auto_off=true; manual_BASEATTACK_unchanged=true; triple_jump_return_unchanged=true')
        return
    end
    if action~='DODGEARM' then return end
    local t=trial
    if not t or not t.direct_control or t.target_kind~='PAL' or t.restoring
       or t.pal_lost or t.jump_exit_pending or recovery_lock~=true
       or not pal_control.exact(t,true) then
        log('CVG_DODGE_BLOCKED: exact_owned_pal_possession_required=true; no_native_call=true')
        return
    end
    if not pal_control.dodge_hook_installed then
        log('CVG_DODGE_BLOCKED: rolling_BP_hook_unavailable_on_server=true; do_not_infer_dodge_from_camera=true; no_native_call=true')
        return
    end
    pal_control.dodge_armed=true
    pal_control.dodge_armed_session=t
    log('CVG_DODGE_ARMED: current_owned_Pal_only=true; unlimited_manual_dodge_inputs=true; cooldown_seconds=8_other_Pals_20_Astralym_Cannon; allowed_sources=owned_BP_rolling_or_owner_RPC_exact_rolling_class; Xbox_delivery_unverified=true; no_cast_yet=true')
end
function pal_control.dodge_trigger(sess,source)
    if trial~=sess or not sess or not pal_control.dodge_armed
       or pal_control.dodge_armed_session~=sess or pal_control.dodge_queued
       or sess.restoring or sess.pal_lost or sess.jump_exit_pending
       or not sess.direct_control or recovery_lock~=true
       or not pal_control.exact(sess,true) then return end
    local now=os.time()
    if type(now)~='number' or now-(pal_control.dodge_last_trigger or 0)<8
       or now-(pal_control.base_attack_last_ts or 0)<math.max(8,pal_control.base_attack_last_cooldown or 8) then return end
    if type(ExecuteWithDelay)~='function' or type(ExecuteInGameThread)~='function' then
        log('CVG_DODGE_BLOCKED: no_safe_scheduler=true; no_native_call=true');return
    end
    pal_control.dodge_queued=true
    pal_control.dodge_last_trigger=now
    log('CVG_DODGE_TRIGGER_QUEUED: source='..source..'; exact_owner_session=true; same_species_BASEATTACK=true; no_native_call_yet=true')
    local queued=pcall(function()
        ExecuteWithDelay(150,function()
            local posted=pcall(function() ExecuteInGameThread(function()
                local ok=pcall(function()
                    if trial~=sess or not pal_control.dodge_armed
                       or pal_control.dodge_armed_session~=sess or sess.restoring
                       or sess.pal_lost or sess.jump_exit_pending or recovery_lock~=true
                       or not pal_control.exact(sess,true) then
                        log('CVG_DODGE_BLOCKED: session_changed_before_dispatch=true; no_native_call=true')
                        return
                    end
                    -- Mesmo allowlist de especie e classe nativa do comando manual VALIDADO.
                    pal_control.dodge_attack_calls=pal_control.dodge_attack_calls+1
                    local success,res=pcall(function()return pal_control.base_attack('BASEATTACK')end)
                    if not success or (type(res)=='string' and res:find('status=LUA_ERROR',1,true)) then
                        pal_control.dodge_armed=false
                        pal_control.dodge_armed_session=nil
                        log('CVG_DODGE_BLOCKED: error_in_manual_base_attack; dodge_disarmed=true; native_crash_not_catchable_by_pcall=true')
                    end
                end)
                pal_control.dodge_queued=false
                if not ok then
                    pal_control.dodge_armed=false
                    pal_control.dodge_armed_session=nil
                    log('CVG_DODGE_BLOCKED: dispatch_lua_error; dodge_disarmed=true; no_retry=true')
                end
            end) end)
            if not posted then
                pal_control.dodge_queued=false
                log('CVG_DODGE_BLOCKED: game_thread_queue_failed; no_native_call=true')
            end
        end)
    end)
    if not queued then
        pal_control.dodge_queued=false
        log('CVG_DODGE_BLOCKED: delay_queue_failed; no_native_call=true')
    end
end
function pal_control.dodge_actor_source(sess,action)
    if not valid(action) then return 'UNRESOLVED' end
    local pal_key=sess.pal_key
    local human_key=sess.human_key
    local ok_p,pal_comp=pcall(function()return sess.pal.ActionComponent end)
    local key_comp=ok_p and valid(pal_comp) and actor_key(pal_comp) or nil
    local obj=action
    for depth=0,6 do
        if not valid(obj) then break end
        local key=actor_key(obj)
        if key and (key==pal_key or key==key_comp) then return 'PAL' end
        if key and key==human_key then return 'HUMAN' end
        -- Outer e a cadeia nativa de propriedade UObject; sem nomes de outros Pals.
        local ok_next,nxt=pcall(function()return obj:GetOuter()end)
        if not ok_next or not valid(nxt) or actor_key(nxt)==key then break end
        obj=nxt
    end
    return 'UNRESOLVED'
end
function pal_control.dodge_bp_begin(ctx)
    pal_control.dodge_hook_events=pal_control.dodge_hook_events+1
    local sess=trial
    if not sess or sess.target_kind~='PAL' or sess.restoring or sess.pal_lost
       or not sess.direct_control or recovery_lock~=true
       or not pal_control.exact(sess,true) then return end
    local ok,action=pcall(function()return ctx:get()end)
    local kind=ok and pal_control.dodge_actor_source(sess,action) or 'UNRESOLVED'
    if kind=='PAL' then pal_control.dodge_owner_events=pal_control.dodge_owner_events+1
    else pal_control.dodge_unresolved_events=pal_control.dodge_unresolved_events+1 end
    if (pal_control.dodge_owner_events+pal_control.dodge_unresolved_events)<=40 then
        log('CVG_DODGE_BP_EVENT: action=NEW_ROLLING; owning_actor='..kind
            ..'; exact_possession=true; armed='..tostring(pal_control.dodge_armed)
            ..'; Xbox_button_mapping_not_proven=true')
    end
    -- Se a origem for HUMANO/UNRESOLVED, nunca usar como autorizacao de ataque.
    if kind=='PAL' then pal_control.dodge_trigger(sess,'EXACT_PAL_BP_ROLL') end
end
function pal_control.dodge_try_install()
    if pal_control.dodge_hook_installed or pal_control.dodge_hook_attempts>=5 then return end
    pal_control.dodge_hook_attempts=pal_control.dodge_hook_attempts+1
    local ok,a,b=pcall(function()
        return RegisterHook(pal_control.dodge_bp_path,function(...)pal_control.dodge_bp_begin(...)end)
    end)
    pal_control.dodge_hook_installed=ok and (a~=nil or b~=nil)
    log('CVG_DODGE_HOOK: path=BP_ActionStep_New_Rolling.OnBeginAction; installed='
        ..tostring(pal_control.dodge_hook_installed)
        ..'; attempt='..tostring(pal_control.dodge_hook_attempts)
        ..'; passive_unless_DODGEARM=true; Xbox_server_event_unproven=true')
end

function pal_control.rt_install_hooks()
    local candidates={
        {'SHOOT','/Script/Pal.PalPlayerController:ShooterComponent_ChangeIsShooting_ToServer'},
        {'AIM','/Script/Pal.PalPlayerController:ShooterComponent_ChangeIsAiming_ToServer'},
        {'ALT','/Script/Pal.PalPlayerController:ShooterComponent_ChangeIsAltShooting_ToServer'},
        {'ACTION','/Script/Pal.PalPlayerController:ActionComponent_PlayAction_ToServer_ForPlayer'},
    }
    for _,entry in ipairs(candidates) do
        local label,path=entry[1],entry[2]
        if pal_control.api(path) then
            local ok,a,b=pcall(function()
                if label=='ACTION' then
                    return RegisterHook(path,function(...) pal_control.rt_action_observe(...) end)
                else
                    return RegisterHook(path,function(...) pal_control.rt_observe(label,...) end)
                end
            end)
            local installed=ok and (a~=nil or b~=nil)
            if installed then pal_control.rt_hook_count=pal_control.rt_hook_count+1 end
            log('CVG_INPUT_HOOK: rpc='..label..'; reflected=true; installed='..tostring(installed)
                ..'; passive_by_default=true; no_cast_on_registration=true')
        else
            log('CVG_INPUT_HOOK: rpc='..label..'; reflected=false; installed=false; no_guess_offsets=true')
        end
    end
end

log('LOADED: v1.11.11 BASE_STABLE_1_11_8_FIXED_ACTION_MANUAL_ONLY_WAZA_DISARMED WAZA_ACTION_EXPERIMENTAL SKILL_WAZA_PAL_ACTION_DIAG CAMPAL_BOSSPAL_AND_CAMBOSS HUMAN_INTERACT_CLIENTRESTART_ON_RETURN NATIVE_SKILL_OBSERVABILITY_NO_DAMAGE_WRITE NO_STALE_RETRY_LOCK_AIM_RPC_SAFE170 BOSS_JETDRAGON_CLIENT_RESTART_55M_OWNER_MULTIPLAYER + WILD_TRIAL_ENABLED_TXT_AND_CHAT + RESYNC_RPC_MANUAL_ONCE_PER_TRIAL + SWAP_METADATA_READONLY + FOCUS_DIAG_READONLY_ON_DEMAND + RANGE_200M_OPTIONAL + CAMERA_READONLY + WILD_MANUAL_RETURN_DIRECT_CLIENT_SYNC + AUTO_UNLOCK_AFTER_VERIFIED_CLEANUP + PAL_LOSS_GUARD + TRIPLE_JUMP; tracked_reference_monitor=ON; journal_lock='..tostring(recovery_lock)..'; multiplayer permitted')
local ready,err=pcall(function()
    if type(RegisterHook)~='function' or type(LoopAsync)~='function' then
        error('required UE4SS functions missing')
    end
    local pre,post=RegisterHook('/Script/Pal.PalGameStateInGame:BroadcastChatMessage',on_chat)
    if pre==nil and post==nil then error('BroadcastChatMessage hook not installed') end
    -- Hook opcional: se esta UFunction nao estiver presente no Palworld, o
    -- restante do mod continua normal e o TXT RETURN permanece operativo.
    local hooked,a,b=pcall(function()
        return RegisterHook('/Script/Engine.Character:OnJumped',on_character_jumped)
    end)
    jump_hook_installed=(hooked and (a~=nil or b~=nil))
    if jump_hook_installed then
        log('JUMP_HOOK_READY: /Script/Engine.Character:OnJumped registered; Xbox jump recognition NOT yet verified')
    else
        log('JUMP_HOOK_UNAVAILABLE: OnJumped hook failed; no triple-jump exit; use TXT RETURN')
    end
    -- Captura e opcional: a UFunction do blueprint da esfera pode nao estar
    -- carregada durante o boot. Sem instalar, nao criar falsas garantias.
    local death_ok,death_pre,death_post=pcall(function()
        return RegisterHook('/Script/Pal.PalCharacter:OnDeadCharacter',on_pal_dead)
    end)
    death_hook_installed=death_ok and (death_pre~=nil or death_post~=nil)
    if death_hook_installed then
        log('PAL_DEATH_HOOK_READY: OnDeadCharacter registrado; evento real nao validado com Pal possuido')
    else
        log('PAL_DEATH_HOOK_UNAVAILABLE: fallback TXT RETURN; morte pode interromper controle')
    end
    local function try_capture_hook()
        if capture_hook_installed then return end
        local capture_ok,cp,ct=pcall(function()
            return RegisterHook('/Game/Pal/Blueprint/Weapon/Other/NewPalSphere/BP_PalSphere_Body.BP_PalSphere_Body_C:CaptureSuccessEvent',on_capture_success)
        end)
        capture_hook_installed=capture_ok and (cp~=nil or ct~=nil)
        if capture_hook_installed then
            log('PAL_CAPTURE_HOOK_READY: CaptureSuccessEvent registrado; pode acontecer apos o alvo desaparecer')
        else
            log('PAL_CAPTURE_HOOK_UNAVAILABLE: captura nao monitorada; NUNCA testar sem backup')
        end
    end
    try_capture_hook()
    -- UFunction BP pode nao existir ao carregar o mod. Tentativa unica tardia
    -- sem executar varreduras nem alterar ativamente qualquer Pal.
    if not capture_hook_installed and type(ExecuteWithDelay)=='function' then
        capture_hook_retry_queued=true
        local delay_ok=pcall(function()ExecuteWithDelay(12000,function()
            capture_hook_retry_queued=false
            try_capture_hook()
        end)end)
        if not delay_ok then capture_hook_retry_queued=false end
    end
    local sp_ok,sp_pre,sp_post=pcall(function()
        return RegisterHook('/Script/Pal.PalSpectateComponent:ServerSyncSpectatorLocation',on_cvg_spectator_sync)
    end)
    spectator_hook_installed=sp_ok and (sp_pre~=nil or sp_post~=nil)
    log('CVGSPEC_SYNC_HOOK: installed='..tostring(spectator_hook_installed)..'; Xbox_client_RPC_delivery_unverified=true; no_fake_server_camera=true')
    local logout_ok,lp,lq=pcall(function()return RegisterHook('/Script/Engine.GameModeBase:Logout',pal_control.logout)end)
    log('PAL_CONTROL_LOGOUT_HOOK: installed='..tostring(logout_ok and (lp~=nil or lq~=nil))..'; native_event_delivery_unverified=true')

    -- A leitura e o teste manual nao precisam de um novo hook de ataque.
    pal_control.native_attack_hook_installed=false
    log('PAL_OWN_SKILL_HOOK_DISABLED: old_PlayAction_hook_not_installed; using_server_rpc_probes=true')
    pal_control.rt_install_hooks()
    pal_control.dodge_try_install()
    -- Blueprint pode carregar somente apos um jogador novo entrar no mundo.
    -- Tentativas limitadas, uma copia do hook, nenhum input alterado.
    if not pal_control.dodge_hook_installed and type(NotifyOnNewObject)=='function' then
        pcall(function()NotifyOnNewObject('/Script/Pal.PalPlayerController',function()
            if not pal_control.dodge_hook_installed then pal_control.dodge_try_install() end
        end)end)
    end
    if not pal_control.dodge_hook_installed and type(ExecuteWithDelay)=='function' then
        pcall(function() ExecuteWithDelay(12000,function()
            pal_control.dodge_try_install()
            if not pal_control.dodge_hook_installed then
                pcall(function() ExecuteWithDelay(20000,function()
                    pal_control.dodge_try_install()
                end)end)
            end
        end)end)
    end
    LoopAsync(2000,function()
        pal_control.tick()
        if not trial or not trial.direct_control then
            pcall(function() pal_control.mobile_update_state(false) end)
        end
        local ok,request=pcall(read_request)
        if ok then handle_request(request)
        else log('PRIVATE_FILE_READ_ERROR: unable to read request file') end
        return false
    end)
end)
if ready then
    pcall(function() pal_control.mobile_update_state(true) end)
    log('CVG_TARGET_LOCK_READY: manual_cone_deg=65; acquire_m=35; retain_m=60; scan_limit=512; same_actor_yaw_before_attack_only=true; no_Xbox_reticle_or_auto_fire=true')
    log('CVG_ATTACK_CATALOG_READY: species=308; npc_weapon_use_id=362; npc_punch_id=1; npc_cull_m=5000; gun_first=true; no_auto_fallback_after_native_cast=true; Xbox_unverified=true')
    log('CVG_MOBILE_BRIDGE_READY: status=cvg_mobile_status.json; session_token_exact=true; armed_by_command_only=true; clone_only=true; native_attack_risk=true')
    log('DEATH_DESPAWN_READY: only_exact_dead_wild_pal_after_safe_human_return=true; delay_ms=6000; event_boss_protected=true; capture_unmodified=true; native_risk=true; clone_only=true')
    log('READY: ESQUIVA_XBOX_BP_ROLL_READONLY_UNTIL_DODGEARM; 3_JUMP_RETURN_UNCHANGED; RT_CAST_DISABLED; v1.11.11.6 ASTRALYM_PALDIUMSHOT_ID341_MANUAL_ONLY + v1.11.11.5 HANDOFF_NATIVE_ALREADY_SPECTATING_SKIP_DUPLICATE_BEGINSPECTATE + END_SPECTATE_SEPARATE_850MS_REVALIDATE_PC_HUMAN_WILD_AI_NO_LOOPS + v1.11.11.4 SKILL_AUTO_PROBE_SKIP_AND_NATIVE_NOTICES_OFF + v1.11.11.1 GAME_TOGGLESPECTATE_SNAPSHOT_RETURN_HUMAN_THEN_SPECTATOR_EXPERIMENTAL BASE_v1.11.11 ATTACKVER_PRECHECK_ONLY ATTACK1_SINGLE_NATIVE_TEST_DISABLED_BY_DEFAULT WAZA_DISABLED SKILL_WAZA_PAL_ACTION_DIAG CAMPAL_BOSSPAL_AND_CAMBOSS HUMAN_INTERACTION_RESTART_RPC_ON_VERIFIED_RETURN_PLUS_MANUAL_INTERACT SKILL1_SKILL2_SKILL3_NATIVE_CALLS_WITH_ACTION_COOLDOWN_OBSERVE_250MS_1100MS NO_STALE_RETRY_LOCK_AIM_RPC_SAFE170 BOSS_JETDRAGON_CLIENT_RESTART_AT_55M; BOSS_AUTO_RETURN=OFF; UNPOSSESSED_AUTO_CLEANUP=3MIN; WILD_TRIAL_ENABLED_TXT_AND_CHAT; CAPTURE_GUARD_WILD_ONLY_RESTORE_ON_HUMAN_RETURN; RESYNC_TXT_EXPERIMENT_OFF_UNTIL_EXPLICIT_COMMAND; SWAP_METADATA_READONLY; FOCUS_TXT_DIAGNOSTIC; RANGE_EXPERIMENT_DEFAULT_OFF; CAMERA_DIAGNOSTIC_READ_ONLY; wild_no_duration_or_distance_cutoff; client_handshake_and_view_target_on_entry; experimental death_hook='..tostring(death_hook_installed)..'; capture_hook='..tostring(capture_hook_installed)..'; jump_hook='..tostring(jump_hook_installed)..'; no disconnect watchdog; TXT RETURN; CHAT !cvg ping/npcver/npc/check/trial/npccheck/npctrial/return/status; MULTIPLAYER_ALLOWED; AI_IDLE_ONE_ACTOR_NATIVE_WAKE_DEFAULT_ACTION_AND_QUARANTINE; NPC_HUMAN_CHAT_AND_TXT_ALIASES_ENABLED; ACTIVE_AI_PER_ACTOR_RECOVERY_NO_GLOBAL_LOCK; SERVER_SPECTATOR_CAMERA_AIM_15M_IF_RPC_ROTATION_ELSE_8M; BOSSPAL_ELIGIBLE_WILD_OR_BOSS_AI_RAID_TOWER_EXCLUDED; SAFEON_RETURNS_170M_IF_ENABLED; CVGSPEC_NATIVE_BEGINSPECTATE_RPC_HOOK_EXPERIMENTAL; SKILLCHECK_PAL_EQUIP_WAZA_ACTION_READONLY; PLAYSKILL_RET_FALSE_REJECTED; POSSESSION_NET_3D_ACTOR_ONLY_3KM_40HZ_PULSE4S; OWN_PAL_ARRAY_FALLBACK_DIAGNOSTIC_NO_AUTO_ATTACK; CAMPAL_NATIVE_CAMERA_RPC_BRIDGE_DIAG; NO guarantees.')
else
    log('DISABLED: '..tostring(err))
end
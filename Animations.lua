return {-- ✅ / ❌
    -- Shogun
    ["118154222392812"] = { -- Green Double Slash
        type = "parry",
        t = {0.65, 1.45}
    },

    ["86527092652774"] = 0.575, -- Single Diagonal Slash

    ["134600514326413"] = { -- Kick into Slash
        type = "parry",
        t = {0.635, 1.925}
    },

    -- Dodge animations
    -- Unparryable: Q normally, F with "Parry Unparryables" enabled
    ["124963391435150"] = { -- Red Double Slash
        type = "dodge",
        t = {0.9, 1.575}
    },

    ["129588531110694"] = { -- Crouch Low Slash
        type = "crouch",
        t = 0.4565
    },

    ["112423929319383"] = { -- Jump Stomps + Slashes✅
        {type = "jump",  t = 0.4},
        {type = "parry", t = 1.2},
        {type = "parry", t = 1.725},
        {type = "jump",  t = 2.3},
    },

    ["76782656543761"] = { -- Flurry
        {type = "parry", t = 0.375},
        {type = "dodge", t = 1.2},
        {type = "parry", t = 2.15},
        {type = "parry", t = 2.5},
    },

    ["87084893315096"] = { -- Ultimate
        {type = "parry", t = 0.35},
        {type = "parry", t = 0.775},
        {type = "dodge", t = 1.45},
        {type = "dodge", t = 1.825},
        {type = "parry", t = 2.7},
        {type = "parry", t = 3.1},
        {type = "parry", t = 3.65},
        {type = "parry", t = 4.1},
    },

    -- Imported from another script's data
    -- parryPoints there are gaps (first = time from start, then time after the previous hit), so they are summed here.
    -- roll = true entries are dodges. Per-animation range/delay settings are not part of this format.

    ["650507779"] = { -- Golem Scream
        type = "dodge",
        t = 0.2
    },

    ["130877926065710"] = { -- DarkDemonExplosion
        type = "dodge",
        t = 0.65
    },

    ["96701006735071"] = 0.6, -- DarkStomp
    ["75119009295288"] = { -- DarkSwipe
        type = "dodge",
        t = 0.65
    },

    ["97269504567525"] = { -- QuadSwipe
        type = "parry",
        t = {0.35, 0.8, 1.25, 1.7, 2.15, 2.6, 3.05}
    },

    ["9544203895"] = { -- BounderCharge
        type = "dodge",
        t = 1
    },

    ["9544192782"] = 0.45, -- BounderSwipe1
    ["14531935090"] = 0.6, -- SlamChaser
    ["10739102450"] = 0.45, -- SharkoCoral
    ["9544183744"] = 0.45, -- BounderSwipe2
    ["7639988883"] = 0.65, -- Owl Swipe 2
    ["12496646061"] = 0.45, -- EyeofMaliceRunning
    ["6500704554"] = { -- Golem Smash
        type = "dodge",
        t = 0.4
    },

    ["7626771915"] = 0.33, -- SpearV2Swing
    ["89177958009696"] = 0.35, -- EtreanFirstSwing
    ["103284896140202"] = 0.35, -- EtreanFirstSwing2
    ["97447284729710"] = 0.35, -- EtreanFirstSwing3
    ["95084976730503"] = 0.35, -- EtreanFirstSwing4
    ["95605722077074"] = 0.35, -- EtreanFirstCrit2
    ["110691694093015"] = 0.9, -- SilentheartLightweaponGap
    ["100709561068031"] = 0.35, -- SilentheartUpperLightweapon
    ["104396998895690"] = 0.35, -- EtreanFirstCritical
    ["17116105751"] = 0.36, -- PyreCritRunning
    ["8375086403"] = 0.4, -- MasterFlourish
    ["11573034823"] = 0.22, -- Mudskipper Swing 1
    ["16654105888"] = 0.35, -- ImperialStaffSwing2
    ["101606363724786"] = 0.4, -- ImperatorEdgeCritical
    ["137594192318552"] = { -- Impel
        type = "parry",
        t = {0.35, 0.45, 0.55, 0.65}
    },

    ["6385078248"] = 0.2, -- ClutchingShadow
    ["18445489160"] = 0.4, -- ClawAirCritical
    ["18445492872"] = 0.4, -- ClawGroundCritical
    ["6054920207"] = 0.35, -- IceImpale
    ["4699358112"] = 0.36, -- TESTING-ATTACKRUN
    ["18742913661"] = 0.4, -- TableFlip
    ["7350770431"] = 0.45, -- DaggerCritical
    ["7018083796"] = 0.4, -- Enforcer Swing 2
    ["12138857946"] = 0.4, -- EyeOfMaliceSwing
    ["12138860062"] = 0.4, -- EyeOfMaliceSwing2
    ["12138861998"] = 0.4, -- EyeOfMaliceSwing3
    ["12138863931"] = 0.4, -- EyeOfMaliceSwing4
    ["12138869158"] = 0.45, -- EyeOfMaliceCrit
    ["8310877920"] = 0.45, -- WindGun
    ["132792155877270"] = 0.45, -- EmnityAxeCrit
    ["13610101542"] = 0.45, -- StormseyeCritical
    ["13599246952"] = 0.45, -- StormseyeCritStance1
    ["13599258715"] = 0.01, -- StormseyeCritStance2
    ["13599352721"] = 0.01, -- StormseyeCritStance3
    ["9928429385"] = 0.35, -- MusketSwing1
    ["9928485641"] = 0.35, -- MusketSwing2
    ["9930447958"] = 0.35, -- MusketSwing3
    ["8857099063"] = 0.45, -- StormBlades
    ["5750296638"] = 0.55, -- JoltGrab
    ["138417702895229"] = 0.35, -- CrescendoSwing5
    ["77966503093128"] = 0.45, -- VigilLongswordCrit
    ["121003629056681"] = 0.45, -- BloodFoulerSwing
    ["99450771029342"] = 0.45, -- BloodFoulerSwing2
    ["74422917176963"] = 0.45, -- BloodFoulerSwing3
    ["84010010955504"] = 0.75, -- BloodFoulerCritical
    ["117202493332843"] = 0.35, -- BloodFoulerRunCrit
    ["13799614234"] = 0.15, -- Squibbo1
    ["13799655062"] = 0.15, -- Squibbo2
    ["13799693320"] = 0.15, -- Squibbo3
    ["7576748728"] = 0.32, -- aerial 1
    ["17197593993"] = 0.29, -- PyreekeeperM1
    ["9597289518"] = 0.4, -- Karita Flourish
    ["7627372304"] = 0.35, -- SpearSwing1
    ["17108258606"] = 0.45, -- BruteSwing1
    ["10451138202"] = { -- BruteSwipe1
        type = "dodge",
        t = 0.45
    },

    ["10451145418"] = { -- BruteSwipe2
        type = "dodge",
        t = 0.45
    },

    ["10451150713"] = { -- BruteDrill
        type = "dodge",
        t = 0.65
    },

    ["10451129790"] = { -- BruteSlam
        type = "dodge",
        t = 0.7
    },

    ["14435770311"] = 0.35, -- OneHandedShot1
    ["14435773739"] = 0.35, -- OneHandedShot2
    ["14435778571"] = 0.35, -- OneHandedShot3
    ["5680585677"] = { -- LionfishBites
        type = "parry",
        t = {0.4, 1.5, 3.3}
    },

    ["11710316011"] = { -- SharkoBiteWater
        type = "dodge",
        t = 0.35
    },

    ["100404024900445"] = 0.35, -- StonesparkSwing2
    ["134454349271430"] = 0.35, -- StonesparkSwing
    ["134961845162650"] = 0.5, -- StonesparkHeavyP
    ["9356892933"] = 0.4, -- MechalodauntGun
    ["9357410713"] = 1.5, -- MechalodauntBeam
    ["5641574212"] = 0.35, -- SharkoScream
    ["8041947316"] = 0.45, -- TurtleStampede
    ["6728950754"] = { -- TurtleTripleSwipe
        type = "parry",
        t = {0.4, 1.4, 2.4, 3.4}
    },

    ["6728862735"] = 0.45, -- TurtleStandSwipe
    ["14435766591"] = 0.33, -- PistolSwing2
    ["8228293862"] = { -- PoisonBreath
        type = "dodge",
        t = 0.45
    },

    ["121029419529086"] = 0.4, -- DeathFromAbove
    ["9941118927"] = 0.3, -- AngelSlash
    ["9919986614"] = 0.5, -- SinisterHalo
    ["94626092299428"] = 0.35, -- SpectralGraspSwing1
    ["88620745767944"] = 0.35, -- SpectralGraspSwing2
    ["137565901647190"] = 0.35, -- SpectralGraspSwing3
    ["131207934895342"] = 0.4, -- SpectralGraspCritical
    ["13527506971"] = { -- ChainPull
        type = "dodge",
        t = 0.5
    },

    ["11186652658"] = 0.35, -- LFTSwing
    ["11186654931"] = 0.35, -- LFTSwing2
    ["11186656574"] = 0.35, -- LFTSwing3
    ["15118919161"] = 0.4, -- LFTCritical
    ["15105011815"] = 0.4, -- LFTCritical2
    ["15106225064"] = 0.7, -- LFTCritical3
    ["15104780537"] = 0.4, -- LFTNavaeCrit
    ["8161039359"] = 0.4, -- LegionKataSwing
    ["8161043368"] = 0.4, -- LegionKataSwing2
    ["8161044711"] = 0.4, -- LegionKataSwing3
    ["8161094751"] = 0.3, -- LegionKataSwing4
    ["8169914770"] = 0.45, -- LegionKataCritical
    ["18129125142"] = 0.4, -- SkyshatterKickUpper
    ["11834549387"] = { -- Stomp Mech
        type = "dodge",
        t = 0.7
    },

    ["16654113357"] = 0.36, -- ImperialStaffSwing3
    ["8290626574"] = { -- DukeStomp
        type = "dodge",
        t = 0.7
    },

    ["8285638571"] = { -- DukePunchSlam
        type = "dodge",
        t = 0.1
    },

    ["16372478422"] = 0.25, -- JusKaritaM1x2
    ["6499077558"] = 0.4, -- Golem Slam
    ["15229223629"] = 0.65, -- Onslaught
    ["9681472252"] = { -- Bonekeeper Charge 2
        type = "dodge",
        t = 0.7
    },

    ["18867175628"] = 0.45, -- BoltcrusherCritical
    ["18866452701"] = 0.8, -- BoltcrusherRunCrit
    ["17120101081"] = 0, -- Coral Crit
    ["101880653361558"] = 0.4, -- SilentheartMediumUpper
    ["85523657178401"] = 0.4, -- SilentheartLightRun
    ["107653610777693"] = 0.4, -- CrescendoDualX1
    ["114108670383026"] = 0.45, -- TwincleaveM1x3
    ["100190998225588"] = 0.4, -- TwincleaveM1x2
    ["123456225328134"] = 0.4, -- TwincleaveM1
    ["73539621266914"] = 0.45, -- CrescendoCritical
    ["16214012662"] = 1.43, -- SkyshatterKick
    ["132405692502171"] = 0.45, -- ScarletCyclone
    ["137313477686049"] = 0.45, -- BloodOrb
    ["14428522483"] = 0.8, -- ViciousDescent
    ["87546275535152"] = 0.2, -- Veinbreaker
    ["8367730650"] = 0.3, -- JustKaritaRunAttack
    ["8265980703"] = 0.35, -- IceLungeShort
    ["16213151807"] = 0.3, -- Twincleave
    ["7318254065"] = 0.55, -- CriticalSword
    ["7599168630"] = 0.2, -- Lightning Blade
    ["6607538047"] = 0.4, -- Kanabo2
    ["11493920418"] = 0.45, -- ScytheImpSwing
    ["11493923277"] = 0.4, -- ScytheSwing2
    ["123056759322514"] = 0.45, -- SkyreapCrit
    ["84773513700650"] = 1, -- Bloodcurdle
    ["77160956516659"] = 0.35, -- WitherbladeSwing
    ["119672037814127"] = 0.35, -- WitherbladeSwing2
    ["113419264758259"] = 0.35, -- WitherbladeSwing3
    ["99308528426034"] = 0.45, -- WitherbladeCritical
    ["74575549085897"] = 0.45, -- FractineCritical
    ["83367609184503"] = 0.45, -- CrimsonRain
    ["84099118348290"] = 0.1, -- SanguineDive
    ["73745318478429"] = 0.25, -- CrimsonRainRecall
    ["14428696078"] = 0.4, -- SoulflareSiphon
    ["122286859045617"] = 0.4, -- RazerBlitz
    ["12564120372"] = 0.41, -- SilentSlideM1
    ["7367818208"] = 0.75, -- GreathammerCrit
    ["9832724876"] = 0.4, -- Rail-m1x2
    ["12106093579"] = 0.35, -- Curved X2
    ["16955614856"] = 0.45, -- WyrmtoothCrit
    ["6428525211"] = 0.3, -- Widow Double
    ["13567686046"] = { -- OxidizingRush
        type = "parry",
        t = {0.4, 0.5, 0.6, 0.7, 0.8}
    },

    ["17116756734"] = { -- PyreCritStand
        type = "parry",
        t = {0.38, 0.48, 0.58, 0.68}
    },

    ["7616100008"] = { -- IceBeam
        type = "parry",
        t = {0.52, 0.62}
    },

    ["14953939237"] = 0.55, -- MetalBall
    ["9832721746"] = 0.32, -- Rail-m1
    ["5786514661"] = { -- Wardens
        type = "dodge",
        t = 0.2
    },

    ["8227878518"] = 0.7, -- Crocco Tail Whip
    ["9209255758"] = 0.4, -- WhalingKnife
    ["7627558238"] = 0.35, -- SpearSwing2
    ["13199310081"] = 0.4, -- CryptCrit
    ["11959603858"] = 0.85, -- EclipseKick
    ["9470857690"] = 0.25, -- ShadeBridgerMulti
    ["6415085564"] = 0.2, -- ShadowGunV2
    ["72369061749089"] = 0.45, -- StoneKnightSwing
    ["138936750616581"] = 0.45, -- StoneKnightSwing2
    ["111024000122473"] = { -- StoneKnightPillar
        type = "dodge",
        t = 0.45
    },

    ["106711913879378"] = { -- StoneKnightKick
        type = "dodge",
        t = 0.45
    },

    ["11493924588"] = 0.35, -- ImperialStaffRunning
    ["16707867563"] = 0.5, -- ImperialCrit
    ["16746044904"] = 0.5, -- ImperialCritAOE
    ["16754870267"] = 0.3, -- ImperialRunCrit
    ["72748965289041"] = 1.2, -- SilentheartMediumGap
    ["10768748584"] = 0.8, -- EnforcerAxeCrit
    ["8131612979"] = { -- Knight Viribus
        type = "dodge",
        t = 0.65
    },

    ["98485831363157"] = 0.45, -- CavalrySaberCrit
    ["91712846887182"] = { -- GreatcannotCrit
        type = "dodge",
        t = 0.8
    },

    ["106858298622632"] = 0.5, -- GreatcannonM1
    ["122256431354649"] = 0.5, -- GreatcannonM1x2
    ["107517860698953"] = 0.45, -- SlicenDice
    ["12071495751"] = 0.5, -- PetrasCrit
    ["12071942369"] = { -- SuperAnchorM1
        type = "dodge",
        t = 0.6
    },

    ["118991358495157"] = 0.45, -- ForgeGreathammerCrit
    ["8150828674"] = 0.4, -- Rapid Punches
    ["8187068153"] = 0.35, -- RadiantKick
    ["13413457604"] = { -- RadiantDawn
        type = "dodge",
        t = 1
    },

    ["7388133473"] = 0.75, -- BattleaxeCrit
    ["11887887621"] = 0.35, -- HeavyUppercut
    ["11887898774"] = 0.3, -- SomeUppercut
    ["11887938902"] = 0.3, -- SomeUppercut2
    ["11887876811"] = 0.3, -- SomeUppercut3
    ["11887892548"] = 0.3, -- SomeUppercut4
    ["11887901212"] = 0.3, -- SomeUppercut5
    ["6030770341"] = 0.3, -- HeavenlyWind
    ["6466993564"] = { -- WindCarve
        type = "parry",
        t = {0.45, 0.5, 0.55}
    },

    ["9767020777"] = 0.7, -- FlashdrawStrike
    ["18953687294"] = 0.35, -- DecimateBladeharper
    ["18939487172"] = 0.35, -- PalmStrike
    ["93913813469029"] = 0.3, -- PyreekeeperRunCrit
    ["17119287814"] = 0.45, -- PyrekeeperAerialCrit
    ["17134046321"] = 0.25, -- PyrekeeperSlidingCrit
    ["16899875441"] = 0.49, -- FrostGrabFixed
    ["8199600822"] = 0.4, -- AshSlam
    ["18589175041"] = 0.5, -- ChainwardenRestrain2
    ["6428533082"] = { -- Widow Bite
        type = "dodge",
        t = 0.6
    },

    ["7675544287"] = { -- OwlGrab
        type = "dodge",
        t = 0.35
    },

    ["9422599069"] = 0.35, -- ShoulderBash
    ["16372427756"] = 0.33, -- PurpledSwing3
    ["12106095892"] = 0.35, -- Curved X3
    ["123115833203242"] = 0.35, -- ImperiumKataM1
    ["131576892263777"] = 0.35, -- ImperiumKataM1x2
    ["90742361803263"] = 0.35, -- ImperiumKataM1x3
    ["128613582420698"] = 0.45, -- TitusThrow
    ["97570885662399"] = 0.4, -- ImperiumCrit
    ["7351158603"] = 0.35, -- SpearCritical
    ["7942002115"] = 0.4, -- Crabbo i forgor
    ["9551012380"] = 0.6, -- MetalEruption
    ["9726608174"] = 0.5, -- Judgement
    ["5769343416"] = 0.35, -- BurningServantsYOUNOTPARRYINGFROZEN
    ["5121733951"] = { -- Sharko Double
        type = "parry",
        t = {0.35, 0.95}
    },

    ["17108275299"] = 0.4, -- BrutePunch2
    ["16372412925"] = 0.33, -- PurpledSwing
    ["7938093143"] = { -- CrabboGrab
        type = "dodge",
        t = 0.6
    },

    ["7003342450"] = { -- ElectroCarveNPC
        type = "parry",
        t = {0.35, 0.5, 0.65, 0.8, 0.95, 1.1}
    },

    ["8286153000"] = 0.4, -- DukeWindArrow
    ["12921226261"] = 0.75, -- ClubCrit
    ["13269418897"] = 0.35, -- MetalKickSpring
    ["91060638385027"] = 0.45, -- DuskguardAxeCrit
    ["127907374073443"] = 1, -- ScoundreCrit
    ["8285534401"] = 0.5, -- WindStomp
    ["8285321158"] = 0.87, -- DukeBombGrab
    ["6501044846"] = 0.45, -- Golem Stomp
    ["7019686291"] = 0.4, -- Enforcer Kick
    ["6063188218"] = 0.3, -- Karita 2
    ["17197704130"] = 0.288, -- PyrekeeperM1x2
    ["17292769123"] = 0.552, -- WardenCrit
    ["17115889868"] = { -- PyreCritCrouch
        type = "parry",
        t = {0.367, 0.467, 0.567, 0.667}
    },

    ["8278933540"] = 0.25, -- JusKaritaM1x4
    ["8131374542"] = 0.33, -- Knight Air
    ["12333753799"] = 0.3,
    ["6701095669"] = 0.39, -- ShadowMeteors
    ["15238144593"] = 0.25, -- Relentless Flame
    ["5774829118"] = 0.55, -- FlameRepulsion
    ["9536688585"] = 0.5, -- ArcwanderCast
    ["9481400792"] = 0.3, -- ArcBeam
    ["11834551880"] = { -- Mech Swipe
        type = "dodge",
        t = 1.2
    },

    ["7673097597"] = { -- OwlGrab
        type = "dodge",
        t = 0.37
    },

    ["8176091986"] = 1, -- Crabbo Double Slam
    ["18585956004"] = 0.5, -- ChainwardenRestrain
    ["8194213529"] = 0.3, -- FistAerialAttack
    ["8183996606"] = 0.4, -- Gran Javelin Small
    ["16021787986"] = 0.45, -- ShatteredCrit
    ["18556305100"] = 0.35, -- NocturneCritV2
    ["5828315760"] = 0.15, -- AirForce
    ["7616407967"] = 0.3, -- FistPunch
    ["17108826294"] = { -- BruteLeap
        type = "dodge",
        t = 0.6
    },

    ["11887874227"] = 0.4, -- SwordUppercut
    ["7543723607"] = 0.8, -- IceSpike
    ["6470684331"] = 0.31, -- AstralWind
    ["106452000190522"] = { -- HallowtideCannonCrit
        type = "dodge",
        t = {0.5, 1, 1.5, 2}
    },

    ["101584283427561"] = 0.44, -- CannonRunAttack
    ["15420044707"] = 0.3, -- Karita Leap
    ["70499364296634"] = 0.4, -- UmbralSlash
    ["9657469282"] = 0.1, -- Vent
    ["8378263543"] = 0.35, -- PleekstyCrit
    ["16654099937"] = 0.35, -- ImperialStaffSwing
    ["13527611147"] = { -- ChainPull
        type = "dodge",
        t = 0.5
    },

    ["8018881257"] = 0.33, -- ShadowEruption
    ["6428519131"] = 0.4, -- Widow Left
    ["5963021481"] = 0.35, -- MeteorSlam
    ["7618754583"] = 0.4, -- GalePunch
    ["7576614609"] = 0.4, -- aerial 2
    ["16550960639"] = 0.45, -- MetalFakeout
    ["11468287607"] = 0.4, -- HeroShadowCrit
    ["11183196198"] = 0.4, -- HerobladeIce
    ["11308969885"] = 0.4, -- HerobladeFire
    ["11312302005"] = 0.4, -- HerobladeGale
    ["10904625331"] = 0.4, -- HerobladeLightning
    ["17481293842"] = { -- GaleSaint
        type = "dodge",
        t = 0.35
    },

    ["17481282052"] = 0.9, -- FireSaint
    ["17481300369"] = 0.3, -- IceSaint
    ["17481296528"] = 0.45, -- ShadowSaint
    ["17481286354"] = 0.45, -- LightningSaint
    ["15331452847"] = { -- ElectroCarve
        type = "parry",
        t = {0.75, 0.85, 0.95, 1.05, 1.15, 1.25, 1.35}
    },

    ["18109620534"] = 0.34, -- PleekstyRunCrit
    ["15881820093"] = 0.35, -- FlashFireSweep
    ["17742747596"] = 0.4, -- AerialShotV2
    ["8249177669"] = 0.32, -- RapiersM1x2
    ["12378124969"] = 0.1, -- Ceaseless Slashes
    ["9832727905"] = 0.32, -- Rail-m1x3
    ["9930618934"] = 0.45, -- MusketKick
    ["5953326460"] = 0.45, -- RisingFlame
    ["8467835626"] = 0.5, -- IceForge
    ["8130745441"] = 0.4, -- Knight Swing 1
    ["8230353450"] = { -- Crocco Dig
        type = "dodge",
        t = 0
    },

    ["14435763579"] = 0.33, -- PistolSwing1
    ["8066909599"] = 0.4, -- Revenge
    ["8249271040"] = 0.32, -- RapiersCrit
    ["16394277950"] = 0.5, -- TwisterKicks
    ["133310040571072"] = 0.6, -- MantleAerial
    ["132164383275060"] = 0.4, -- SilentheartMediumRun
    ["18322559443"] = 0.45, -- KyrswinterCrit
    ["6318273143"] = 0.3, -- ShadowAssault
    ["15214200859"] = 0.45, -- RisingThunder
    ["9893133020"] = 0.265, -- RailAirCrit
    ["7599113567"] = 0.5, -- IceDaggers
    ["18441684191"] = 0.8, -- KanaboTripleSmash
    ["8226933122"] = { -- Crocco Triple
        type = "parry",
        t = {0.4, 0.84, 1.28}
    },

    ["13253662736"] = 0.45, -- NeedleBarrage
    ["9629695751"] = 0.55, -- ChampWhirlthrow
    ["9681916972"] = { -- bonekeeper 1
        type = "dodge",
        t = 0.65
    },

    ["6432920452"] = 0.4, -- SecundaryShot
    ["6669352471"] = 0.39, -- GSRunAttack
    ["10258479464"] = 0.7, -- DarksteelCrit
    ["9234812388"] = { -- Iceberg
        type = "parry",
        t = {0.2, 0.4, 0.6, 0.8, 1, 1.2, 1.4}
    },

    ["7018046790"] = 0.4, -- Enforcer Swing 1
    ["6675703249"] = 0.34, -- CryptM1x2
    ["13241958217"] = 0.35, -- FirstLightSwing
    ["13242083070"] = 0.35, -- FirstlightSwing2
    ["17116112176"] = 0.37, -- PyreCritRun
    ["8130778356"] = 0.4, -- Knight Swing 2
    ["9681905891"] = 0.8, -- Bonekeeper Charge
    ["11572468462"] = 0.22, -- Mudskipper Swing 2
    ["7391446645"] = 0.65, -- NavaeCrit
    ["12706574441"] = 0.45, -- ProminenceDraw
    ["17665718967"] = 0.27, -- FlameVolley
    ["7019018522"] = { -- Enforcer Spin
        type = "parry",
        t = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1}
    },

    ["7861127585"] = 0.6, -- ThunderKick
    ["7861135817"] = 0.5, -- ThunderkickV2
    ["7600450739"] = 0.33, -- SwordV2Style
    ["5120461115"] = 0.35, -- ArdourScream
    ["7542502881"] = 0.45, -- FlameLeap
    ["105327179871000"] = 0.45, -- ForgeGreathammerCrit
    ["17363185033"] = 0.45, -- TridentCrit
    ["6017393708"] = 0.35, -- GaleLungeShort
    ["6017418456"] = 0.35, -- GaleLungeFar
    ["9484850093"] = 0.35, -- GranSudaKick
    ["5064195992"] = 0.35, -- GreataxeSwingX1
    ["18967397842"] = { -- EnmityHomerun
        type = "dodge",
        t = 0.65
    },

    ["18967389067"] = { -- EnmityStompSlice
        type = "parry",
        t = {0.75, 2.1}
    },

    ["131597866888761"] = { -- EnmityExecute
        type = "dodge",
        t = 0.8
    },

    ["18966790283"] = { -- EnmityLeftRight
        type = "parry",
        t = {0.85, 2.1}
    },

    ["80841795666744"] = { -- TitusCannonCrit
        type = "dodge",
        t = 2
    },

    ["5067105317"] = 0.35, -- GreataxeSwingX2
    ["5067090007"] = 0.35, -- GreataxeSwingX3
    ["7014547998"] = 0.45, -- DragonTail
    ["7014172795"] = { -- DragonSwipe
        type = "parry",
        t = {0.45, 1.1}
    },

    ["9212883524"] = 0.6, -- HalberdCrit
    ["7794260173"] = 0.3, -- RisingWind
    ["9359697890"] = 0.35, -- ShadowDevour
    ["108775350619127"] = 0.35, -- Updraft
    ["109165501462354"] = 0.6, -- KyrsglaiveCritical
    ["7627049402"] = 0, -- spear 1 hand 2
    ["18510057229"] = 0.71, -- SoulthornCrit
    ["7600485223"] = 0.33, -- SwordV2Style2
    ["8379406836"] = 0.4, -- Rapid Slashes
    ["16873988732"] = 0.35, -- JetKick
    ["117160121128317"] = 0.45, -- GreatmaulCrit
    ["102858834757078"] = 0.35, -- KindredEdictSwing
    ["106608030834708"] = 0.35, -- KindredEdictSwingx2
    ["111781160894259"] = 0.35, -- KindredEdictSwingx3
    ["123780310762764"] = 0.35, -- KindredEdictGroundCrit
    ["125807467678893"] = 0.35, -- KindredEdictGroundCritx2
    ["90021911048794"] = 0.35, -- KindredEdictAirCrit
    ["5827250000"] = 0.45, -- SpearRunAttack
    ["125088776029027"] = 0.35, -- RiteOfAuthorityCrit
    ["81791470214091"] = 0.1, -- SlamAuthority
    ["13262891882"] = { -- MetalKick
        type = "dodge",
        t = 0.8
    },

    ["17108040817"] = 0.35, -- GunRunningAttack
    ["5641344204"] = { -- Sharko Grab
        type = "dodge",
        t = 0.2
    },

    ["6432260013"] = { -- Monkey Triple
        type = "parry",
        t = {0.8, 1.55, 2.3, 3.05}
    },

    ["9400896040"] = 0.45, -- ShoulderBash
    ["9710538334"] = { -- Bonekeeper Choke
        type = "dodge",
        t = 0.3
    },

    ["12108376249"] = 0.3, -- EclipseKick
    ["13529982886"] = 0.7, -- MetalIronHug
    ["9422278968"] = 0.9, -- CarbuncleFlail
    ["14954130177"] = 0.2, -- CaltropsV1
    ["126184250609926"] = 0.4, -- IronQuills
    ["13472893499"] = 0.6, -- IronSlam
    ["13643852843"] = 0.4, -- RocketLance
    ["7617742471"] = 0.2, -- Lightning Beam
    ["7600160919"] = 0.34, -- SwordSwing1
    ["9681421310"] = 0.6, -- Bonekeeper Sweep
    ["5117879514"] = 0.35, -- Sharko Swipe
    ["12106091136"] = 0.35, -- Curved X1
    ["16372479940"] = 0.25, -- JusKaritaM1x3
    ["13989464729"] = 0.7, -- GranSudaCrit
    ["17666279427"] = 0.35, -- GuidingStarM1
    ["17666284182"] = 0.35, -- GuidingStarM1x2
    ["17666287806"] = 0.35, -- GuidingStarM1x3
    ["123321475025790"] = 0.45, -- GuidingStarCrit
    ["112381112390648"] = 0.45, -- GuidingStarRunning
    ["92625055798566"] = 0.45, -- GuidingStarAerial
    ["16372422960"] = 0.33, -- PurpledSwing2
    ["18592047703"] = 0.4, -- ChainwardenRupture
    ["9863424290"] = 0.4, -- RailGroundCrit
    ["82111969749817"] = 1, -- SilentheartHeavyGap
    ["139465383955578"] = 0.45, -- SilentheartHeavyUpper
    ["17481307114"] = 0.45, -- ArdourSlicer
    ["117058220308511"] = 0.45, -- PleeskySwing2
    ["137978211994071"] = 0.45, -- PleeskySwing1
    ["104616759679357"] = 0.45, -- PleeskySwing3
    ["136701179709286"] = 0.45, -- RedDeathRunCrit
    ["110510943038279"] = 0.65, -- WretchenMawbladesCrit
    ["76842464533258"] = 0.6, -- RedDeathStandCrit
    ["93362023058024"] = 0.4, -- LegionMasteryFlourish
    ["18442438270"] = { -- FlamingScourgeAttempt
        type = "dodge",
        t = 0.55
    },

    ["17665624417"] = 0.1, -- RythmnAdvance
    ["7830946229"] = 0.35, -- ShotelCritical
    ["17665602554"] = 0.2, -- TacetKickV2
    ["18553734325"] = 0.65, -- NocturneCrit
    ["18445833385"] = 1.1, -- KanaboCrit
    ["8085349676"] = 0.45, -- Strong Left
    ["101420289979512"] = 0.45, -- TwinstrikesX1
    ["109488905019243"] = 0.45, -- TwinstrikesX2
    ["8131156119"] = { -- Knight Kick
        type = "dodge",
        t = 0.4
    },

    ["6437665734"] = 0.4, -- PrimaryShot
    ["6675698010"] = 0.34, -- CryptM1
    ["108318311802227"] = 0.45, -- DODGE
    ["80865399851806"] = { -- KickFollowupTitus
        type = "dodge",
        t = 0.3
    },

    ["7827886914"] = 0.45, -- Nemesis Crit
    ["8198492537"] = 0.35, -- ExhaustionStrike
    ["14181029595"] = { -- PrecisionCuts
        type = "parry",
        t = {0.35, 0.7, 1.05, 1.4, 1.75}
    },

    ["14181944470"] = 0.6, -- CloseShave
    ["5063313656"] = 0.35, -- DaggerRunAttack
    ["6607519294"] = 0.4, -- Kanabo3
    ["9501936889"] = 0.8, -- CarbuncleLeap
    ["8198764550"] = 0.16, -- SingxTaunt
    ["6501497627"] = { -- Golem Cyclone
        type = "parry",
        t = {3.6, 3.7}
    },

    ["8172871094"] = { -- KyrseigerCrit
        type = "dodge",
        t = 1.8
    },

    ["16387878472"] = 0.16, -- PurpledCrit
    ["5827423063"] = 0.35, -- SpearRunAttack
    ["5950080662"] = 0.3, -- DaggerM1x4
    ["8375571405"] = { -- PressureBlast
        type = "parry",
        t = {0.6, 0.8, 1}
    },

    ["12772036355"] = 0.35, -- Punishment
    ["7639648215"] = 0.35, -- OwlSwipe
    ["18208445321"] = 0.6, -- SpindleCrit
    ["18101585968"] = 0.34, -- PleekstyCrit
    ["8227583745"] = { -- Crocco Double Swipe
        type = "parry",
        t = {0.4, 1.1}
    },

    ["13408478146"] = { -- MetalRain
        type = "dodge",
        t = 0.8
    },

    ["18592050844"] = 0.4, -- ChainwardenRupture2
    ["18319686489"] = { -- KyrswinterRunCrit
        type = "dodge",
        t = 1.4
    },

    ["8249175106"] = 0.32, -- RapierSwing1
    ["8046864635"] = 0.5, -- FireBlade
    ["15121611060"] = 0.45, -- RisingFrost
    ["7627889074"] = 0.22, -- DaggerM1x2
    ["7598898608"] = 0.5, -- IceSmash
    ["130566156191218"] = 0.65, -- DeathReverieCrit
    ["82342705344145"] = 0.35, -- TwinbladeRunAttack
    ["103325425676000"] = 0.45, -- TwinbladeCrit
    ["10053070573"] = 0.45, -- CrescentCrit
    ["11710417615"] = 0.35, -- Sharko Coral
    ["17117274013"] = 0.36, -- PyreCritRunSlash
    ["7600224169"] = 0.34, -- SwordSwing2
    ["13338519421"] = 0.77, -- MetalGatling
    ["16372476897"] = 0.25, -- JustKaritaM1
    ["16961331275"] = 0.45, -- WyrmSlideV2
    ["115289020018430"] = 0.25, -- DreadWhisper
    ["7627854272"] = 0.22, -- DaggerM1
    ["18109641443"] = { -- SoulthornCritV2
        type = "parry",
        t = {0.29, 0.39, 0.49, 0.59, 0.69}
    },

    ["7543558046"] = 0.455, -- FlameAssault
    ["11363599835"] = 0.4, -- HeavyAerialAttack
    ["7794268358"] = 0.35, -- RisingWindCast
    ["16926301301"] = 0.45, -- Fakekick
    ["17197732174"] = 0.28, -- PyreekeperM1x3
    ["17108566269"] = { -- BruteHeavyPunch
        type = "dodge",
        t = 0.6
    },

    ["13529984980"] = 0.3, -- MetalIronHug
    ["16079914008"] = { -- Iceflock
        type = "dodge",
        t = {0.5, 0.7, 0.9, 1.1, 1.3, 1.5, 1.7}
    },

    ["11710290503"] = { -- Sharko Kick
        type = "dodge",
        t = 0.45
    },

    ["6063195211"] = 0.3, -- Karita 3
}

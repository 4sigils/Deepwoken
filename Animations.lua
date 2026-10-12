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
        t = 0.175
    },

    ["130877926065710"] = { -- DarkDemonExplosion
        type = "dodge",
        t = 0.625
    },

    ["96701006735071"] = 0.575, -- DarkStomp
    ["75119009295288"] = { -- DarkSwipe
        type = "dodge",
        t = 0.625
    },

    ["97269504567525"] = { -- QuadSwipe
        type = "parry",
        t = {0.325, 0.775, 1.225, 1.675, 2.125, 2.575, 3.025}
    },

    ["9544203895"] = { -- BounderCharge
        type = "dodge",
        t = 0.975
    },

    ["9544192782"] = 0.425, -- BounderSwipe1
    ["14531935090"] = 0.575, -- SlamChaser
    ["10739102450"] = 0.425, -- SharkoCoral
    ["9544183744"] = 0.425, -- BounderSwipe2
    ["7639988883"] = 0.625, -- Owl Swipe 2
    ["12496646061"] = 0.425, -- EyeofMaliceRunning
    ["6500704554"] = { -- Golem Smash
        type = "dodge",
        t = 0.375
    },

    ["7626771915"] = 0.305, -- SpearV2Swing
    ["89177958009696"] = 0.325, -- EtreanFirstSwing
    ["103284896140202"] = 0.325, -- EtreanFirstSwing2
    ["97447284729710"] = 0.325, -- EtreanFirstSwing3
    ["95084976730503"] = 0.325, -- EtreanFirstSwing4
    ["95605722077074"] = 0.325, -- EtreanFirstCrit2
    ["110691694093015"] = 0.875, -- SilentheartLightweaponGap
    ["100709561068031"] = 0.325, -- SilentheartUpperLightweapon
    ["104396998895690"] = 0.325, -- EtreanFirstCritical
    ["17116105751"] = 0.335, -- PyreCritRunning
    ["8375086403"] = 0.375, -- MasterFlourish
    ["11573034823"] = 0.195, -- Mudskipper Swing 1
    ["16654105888"] = 0.325, -- ImperialStaffSwing2
    ["101606363724786"] = 0.375, -- ImperatorEdgeCritical
    ["137594192318552"] = { -- Impel
        type = "parry",
        t = {0.325, 0.425, 0.525, 0.625}
    },

    ["6385078248"] = 0.175, -- ClutchingShadow
    ["18445489160"] = 0.375, -- ClawAirCritical
    ["18445492872"] = 0.375, -- ClawGroundCritical
    ["6054920207"] = 0.325, -- IceImpale
    ["4699358112"] = 0.335, -- TESTING-ATTACKRUN
    ["18742913661"] = 0.375, -- TableFlip
    ["7350770431"] = 0.425, -- DaggerCritical
    ["7018083796"] = 0.375, -- Enforcer Swing 2
    ["12138857946"] = 0.375, -- EyeOfMaliceSwing
    ["12138860062"] = 0.375, -- EyeOfMaliceSwing2
    ["12138861998"] = 0.375, -- EyeOfMaliceSwing3
    ["12138863931"] = 0.375, -- EyeOfMaliceSwing4
    ["12138869158"] = 0.425, -- EyeOfMaliceCrit
    ["8310877920"] = 0.425, -- WindGun
    ["132792155877270"] = 0.425, -- EmnityAxeCrit
    ["13610101542"] = 0.425, -- StormseyeCritical
    ["13599246952"] = 0.425, -- StormseyeCritStance1
    ["13599258715"] = 0, -- StormseyeCritStance2
    ["13599352721"] = 0, -- StormseyeCritStance3
    ["9928429385"] = 0.325, -- MusketSwing1
    ["9928485641"] = 0.325, -- MusketSwing2
    ["9930447958"] = 0.325, -- MusketSwing3
    ["8857099063"] = 0.425, -- StormBlades
    ["5750296638"] = 0.525, -- JoltGrab
    ["138417702895229"] = 0.325, -- CrescendoSwing5
    ["77966503093128"] = 0.425, -- VigilLongswordCrit
    ["121003629056681"] = 0.425, -- BloodFoulerSwing
    ["99450771029342"] = 0.425, -- BloodFoulerSwing2
    ["74422917176963"] = 0.425, -- BloodFoulerSwing3
    ["84010010955504"] = 0.725, -- BloodFoulerCritical
    ["117202493332843"] = 0.325, -- BloodFoulerRunCrit
    ["13799614234"] = 0.125, -- Squibbo1
    ["13799655062"] = 0.125, -- Squibbo2
    ["13799693320"] = 0.125, -- Squibbo3
    ["7576748728"] = 0.295, -- aerial 1
    ["17197593993"] = 0.265, -- PyreekeeperM1
    ["9597289518"] = 0.375, -- Karita Flourish
    ["7627372304"] = 0.325, -- SpearSwing1
    ["17108258606"] = 0.425, -- BruteSwing1
    ["10451138202"] = { -- BruteSwipe1
        type = "dodge",
        t = 0.425
    },

    ["10451145418"] = { -- BruteSwipe2
        type = "dodge",
        t = 0.425
    },

    ["10451150713"] = { -- BruteDrill
        type = "dodge",
        t = 0.625
    },

    ["10451129790"] = { -- BruteSlam
        type = "dodge",
        t = 0.675
    },

    ["14435770311"] = 0.325, -- OneHandedShot1
    ["14435773739"] = 0.325, -- OneHandedShot2
    ["14435778571"] = 0.325, -- OneHandedShot3
    ["5680585677"] = { -- LionfishBites
        type = "parry",
        t = {0.375, 1.475, 3.275}
    },

    ["11710316011"] = { -- SharkoBiteWater
        type = "dodge",
        t = 0.325
    },

    ["100404024900445"] = 0.325, -- StonesparkSwing2
    ["134454349271430"] = 0.325, -- StonesparkSwing
    ["134961845162650"] = 0.475, -- StonesparkHeavyP
    ["9356892933"] = 0.375, -- MechalodauntGun
    ["9357410713"] = 1.475, -- MechalodauntBeam
    ["5641574212"] = 0.325, -- SharkoScream
    ["8041947316"] = 0.425, -- TurtleStampede
    ["6728950754"] = { -- TurtleTripleSwipe
        type = "parry",
        t = {0.375, 1.375, 2.375, 3.375}
    },

    ["6728862735"] = 0.425, -- TurtleStandSwipe
    ["14435766591"] = 0.305, -- PistolSwing2
    ["8228293862"] = { -- PoisonBreath
        type = "dodge",
        t = 0.425
    },

    ["121029419529086"] = 0.375, -- DeathFromAbove
    ["9941118927"] = 0.275, -- AngelSlash
    ["9919986614"] = 0.475, -- SinisterHalo
    ["94626092299428"] = 0.325, -- SpectralGraspSwing1
    ["88620745767944"] = 0.325, -- SpectralGraspSwing2
    ["137565901647190"] = 0.325, -- SpectralGraspSwing3
    ["131207934895342"] = 0.375, -- SpectralGraspCritical
    ["13527506971"] = { -- ChainPull
        type = "dodge",
        t = 0.475
    },

    ["11186652658"] = 0.325, -- LFTSwing
    ["11186654931"] = 0.325, -- LFTSwing2
    ["11186656574"] = 0.325, -- LFTSwing3
    ["15118919161"] = 0.375, -- LFTCritical
    ["15105011815"] = 0.375, -- LFTCritical2
    ["15106225064"] = 0.675, -- LFTCritical3
    ["15104780537"] = 0.375, -- LFTNavaeCrit
    ["8161039359"] = 0.375, -- LegionKataSwing
    ["8161043368"] = 0.375, -- LegionKataSwing2
    ["8161044711"] = 0.375, -- LegionKataSwing3
    ["8161094751"] = 0.275, -- LegionKataSwing4
    ["8169914770"] = 0.425, -- LegionKataCritical
    ["18129125142"] = 0.375, -- SkyshatterKickUpper
    ["11834549387"] = { -- Stomp Mech
        type = "dodge",
        t = 0.675
    },

    ["16654113357"] = 0.335, -- ImperialStaffSwing3
    ["8290626574"] = { -- DukeStomp
        type = "dodge",
        t = 0.675
    },

    ["8285638571"] = { -- DukePunchSlam
        type = "dodge",
        t = 0.075
    },

    ["16372478422"] = 0.225, -- JusKaritaM1x2
    ["6499077558"] = 0.375, -- Golem Slam
    ["15229223629"] = 0.625, -- Onslaught
    ["9681472252"] = { -- Bonekeeper Charge 2
        type = "dodge",
        t = 0.675
    },

    ["18867175628"] = 0.425, -- BoltcrusherCritical
    ["18866452701"] = 0.775, -- BoltcrusherRunCrit
    ["17120101081"] = 0, -- Coral Crit
    ["101880653361558"] = 0.375, -- SilentheartMediumUpper
    ["85523657178401"] = 0.375, -- SilentheartLightRun
    ["107653610777693"] = 0.375, -- CrescendoDualX1
    ["114108670383026"] = 0.425, -- TwincleaveM1x3
    ["100190998225588"] = 0.375, -- TwincleaveM1x2
    ["123456225328134"] = 0.375, -- TwincleaveM1
    ["73539621266914"] = 0.425, -- CrescendoCritical
    ["16214012662"] = 1.405, -- SkyshatterKick
    ["132405692502171"] = 0.425, -- ScarletCyclone
    ["137313477686049"] = 0.425, -- BloodOrb
    ["14428522483"] = 0.775, -- ViciousDescent
    ["87546275535152"] = 0.175, -- Veinbreaker
    ["8367730650"] = 0.275, -- JustKaritaRunAttack
    ["8265980703"] = 0.325, -- IceLungeShort
    ["16213151807"] = 0.275, -- Twincleave
    ["7318254065"] = 0.525, -- CriticalSword
    ["7599168630"] = 0.175, -- Lightning Blade
    ["6607538047"] = 0.375, -- Kanabo2
    ["11493920418"] = 0.425, -- ScytheImpSwing
    ["11493923277"] = 0.375, -- ScytheSwing2
    ["123056759322514"] = 0.425, -- SkyreapCrit
    ["84773513700650"] = 0.975, -- Bloodcurdle
    ["77160956516659"] = 0.325, -- WitherbladeSwing
    ["119672037814127"] = 0.325, -- WitherbladeSwing2
    ["113419264758259"] = 0.325, -- WitherbladeSwing3
    ["99308528426034"] = 0.425, -- WitherbladeCritical
    ["74575549085897"] = 0.425, -- FractineCritical
    ["83367609184503"] = 0.425, -- CrimsonRain
    ["84099118348290"] = 0.075, -- SanguineDive
    ["73745318478429"] = 0.225, -- CrimsonRainRecall
    ["14428696078"] = 0.375, -- SoulflareSiphon
    ["122286859045617"] = 0.375, -- RazerBlitz
    ["12564120372"] = 0.385, -- SilentSlideM1
    ["7367818208"] = 0.725, -- GreathammerCrit
    ["9832724876"] = 0.375, -- Rail-m1x2
    ["12106093579"] = 0.325, -- Curved X2
    ["16955614856"] = 0.425, -- WyrmtoothCrit
    ["6428525211"] = 0.275, -- Widow Double
    ["13567686046"] = { -- OxidizingRush
        type = "parry",
        t = {0.375, 0.475, 0.575, 0.675, 0.775}
    },

    ["17116756734"] = { -- PyreCritStand
        type = "parry",
        t = {0.355, 0.455, 0.555, 0.655}
    },

    ["7616100008"] = { -- IceBeam
        type = "parry",
        t = {0.495, 0.595}
    },

    ["14953939237"] = 0.525, -- MetalBall
    ["9832721746"] = 0.295, -- Rail-m1
    ["5786514661"] = { -- Wardens
        type = "dodge",
        t = 0.175
    },

    ["8227878518"] = 0.675, -- Crocco Tail Whip
    ["9209255758"] = 0.375, -- WhalingKnife
    ["7627558238"] = 0.325, -- SpearSwing2
    ["13199310081"] = 0.375, -- CryptCrit
    ["11959603858"] = 0.825, -- EclipseKick
    ["9470857690"] = 0.225, -- ShadeBridgerMulti
    ["6415085564"] = 0.175, -- ShadowGunV2
    ["72369061749089"] = 0.425, -- StoneKnightSwing
    ["138936750616581"] = 0.425, -- StoneKnightSwing2
    ["111024000122473"] = { -- StoneKnightPillar
        type = "dodge",
        t = 0.425
    },

    ["106711913879378"] = { -- StoneKnightKick
        type = "dodge",
        t = 0.425
    },

    ["11493924588"] = 0.325, -- ImperialStaffRunning
    ["16707867563"] = 0.475, -- ImperialCrit
    ["16746044904"] = 0.475, -- ImperialCritAOE
    ["16754870267"] = 0.275, -- ImperialRunCrit
    ["72748965289041"] = 1.175, -- SilentheartMediumGap
    ["10768748584"] = 0.775, -- EnforcerAxeCrit
    ["8131612979"] = { -- Knight Viribus
        type = "dodge",
        t = 0.625
    },

    ["98485831363157"] = 0.425, -- CavalrySaberCrit
    ["91712846887182"] = { -- GreatcannotCrit
        type = "dodge",
        t = 0.775
    },

    ["106858298622632"] = 0.475, -- GreatcannonM1
    ["122256431354649"] = 0.475, -- GreatcannonM1x2
    ["107517860698953"] = 0.425, -- SlicenDice
    ["12071495751"] = 0.475, -- PetrasCrit
    ["12071942369"] = { -- SuperAnchorM1
        type = "dodge",
        t = 0.575
    },

    ["118991358495157"] = 0.425, -- ForgeGreathammerCrit
    ["8150828674"] = 0.375, -- Rapid Punches
    ["8187068153"] = 0.325, -- RadiantKick
    ["13413457604"] = { -- RadiantDawn
        type = "dodge",
        t = 0.975
    },

    ["7388133473"] = 0.725, -- BattleaxeCrit
    ["11887887621"] = 0.325, -- HeavyUppercut
    ["11887898774"] = 0.275, -- SomeUppercut
    ["11887938902"] = 0.275, -- SomeUppercut2
    ["11887876811"] = 0.275, -- SomeUppercut3
    ["11887892548"] = 0.275, -- SomeUppercut4
    ["11887901212"] = 0.275, -- SomeUppercut5
    ["6030770341"] = 0.275, -- HeavenlyWind
    ["6466993564"] = { -- WindCarve
        type = "parry",
        t = {0.425, 0.475, 0.525}
    },

    ["9767020777"] = 0.675, -- FlashdrawStrike
    ["18953687294"] = 0.325, -- DecimateBladeharper
    ["18939487172"] = 0.325, -- PalmStrike
    ["93913813469029"] = 0.275, -- PyreekeeperRunCrit
    ["17119287814"] = 0.425, -- PyrekeeperAerialCrit
    ["17134046321"] = 0.225, -- PyrekeeperSlidingCrit
    ["16899875441"] = 0.465, -- FrostGrabFixed
    ["8199600822"] = 0.375, -- AshSlam
    ["18589175041"] = 0.475, -- ChainwardenRestrain2
    ["6428533082"] = { -- Widow Bite
        type = "dodge",
        t = 0.575
    },

    ["7675544287"] = { -- OwlGrab
        type = "dodge",
        t = 0.325
    },

    ["9422599069"] = 0.325, -- ShoulderBash
    ["16372427756"] = 0.305, -- PurpledSwing3
    ["12106095892"] = 0.325, -- Curved X3
    ["123115833203242"] = 0.325, -- ImperiumKataM1
    ["131576892263777"] = 0.325, -- ImperiumKataM1x2
    ["90742361803263"] = 0.325, -- ImperiumKataM1x3
    ["128613582420698"] = 0.425, -- TitusThrow
    ["97570885662399"] = 0.375, -- ImperiumCrit
    ["7351158603"] = 0.325, -- SpearCritical
    ["7942002115"] = 0.375, -- Crabbo i forgor
    ["9551012380"] = 0.575, -- MetalEruption
    ["9726608174"] = 0.475, -- Judgement
    ["5769343416"] = 0.325, -- BurningServantsYOUNOTPARRYINGFROZEN
    ["5121733951"] = { -- Sharko Double
        type = "parry",
        t = {0.325, 0.925}
    },

    ["17108275299"] = 0.375, -- BrutePunch2
    ["16372412925"] = 0.305, -- PurpledSwing
    ["7938093143"] = { -- CrabboGrab
        type = "dodge",
        t = 0.575
    },

    ["7003342450"] = { -- ElectroCarveNPC
        type = "parry",
        t = {0.325, 0.475, 0.625, 0.775, 0.925, 1.075}
    },

    ["8286153000"] = 0.375, -- DukeWindArrow
    ["12921226261"] = 0.725, -- ClubCrit
    ["13269418897"] = 0.325, -- MetalKickSpring
    ["91060638385027"] = 0.425, -- DuskguardAxeCrit
    ["127907374073443"] = 0.975, -- ScoundreCrit
    ["8285534401"] = 0.475, -- WindStomp
    ["8285321158"] = 0.845, -- DukeBombGrab
    ["6501044846"] = 0.425, -- Golem Stomp
    ["7019686291"] = 0.375, -- Enforcer Kick
    ["6063188218"] = 0.275, -- Karita 2
    ["17197704130"] = 0.263, -- PyrekeeperM1x2
    ["17292769123"] = 0.527, -- WardenCrit
    ["17115889868"] = { -- PyreCritCrouch
        type = "parry",
        t = {0.342, 0.442, 0.542, 0.642}
    },

    ["8278933540"] = 0.225, -- JusKaritaM1x4
    ["8131374542"] = 0.305, -- Knight Air
    ["12333753799"] = 0.275,
    ["6701095669"] = 0.365, -- ShadowMeteors
    ["15238144593"] = 0.225, -- Relentless Flame
    ["5774829118"] = 0.525, -- FlameRepulsion
    ["9536688585"] = 0.475, -- ArcwanderCast
    ["9481400792"] = 0.275, -- ArcBeam
    ["11834551880"] = { -- Mech Swipe
        type = "dodge",
        t = 1.175
    },

    ["7673097597"] = { -- OwlGrab
        type = "dodge",
        t = 0.345
    },

    ["8176091986"] = 0.975, -- Crabbo Double Slam
    ["18585956004"] = 0.475, -- ChainwardenRestrain
    ["8194213529"] = 0.275, -- FistAerialAttack
    ["8183996606"] = 0.375, -- Gran Javelin Small
    ["16021787986"] = 0.425, -- ShatteredCrit
    ["18556305100"] = 0.325, -- NocturneCritV2
    ["5828315760"] = 0.125, -- AirForce
    ["7616407967"] = 0.275, -- FistPunch
    ["17108826294"] = { -- BruteLeap
        type = "dodge",
        t = 0.575
    },

    ["11887874227"] = 0.375, -- SwordUppercut
    ["7543723607"] = 0.775, -- IceSpike
    ["6470684331"] = 0.285, -- AstralWind
    ["106452000190522"] = { -- HallowtideCannonCrit
        type = "dodge",
        t = {0.475, 0.975, 1.475, 1.975}
    },

    ["101584283427561"] = 0.415, -- CannonRunAttack
    ["15420044707"] = 0.275, -- Karita Leap
    ["70499364296634"] = 0.375, -- UmbralSlash
    ["9657469282"] = 0.075, -- Vent
    ["8378263543"] = 0.325, -- PleekstyCrit
    ["16654099937"] = 0.325, -- ImperialStaffSwing
    ["13527611147"] = { -- ChainPull
        type = "dodge",
        t = 0.475
    },

    ["8018881257"] = 0.305, -- ShadowEruption
    ["6428519131"] = 0.375, -- Widow Left
    ["5963021481"] = 0.325, -- MeteorSlam
    ["7618754583"] = 0.375, -- GalePunch
    ["7576614609"] = 0.375, -- aerial 2
    ["16550960639"] = 0.425, -- MetalFakeout
    ["11468287607"] = 0.375, -- HeroShadowCrit
    ["11183196198"] = 0.375, -- HerobladeIce
    ["11308969885"] = 0.375, -- HerobladeFire
    ["11312302005"] = 0.375, -- HerobladeGale
    ["10904625331"] = 0.375, -- HerobladeLightning
    ["17481293842"] = { -- GaleSaint
        type = "dodge",
        t = 0.325
    },

    ["17481282052"] = 0.875, -- FireSaint
    ["17481300369"] = 0.275, -- IceSaint
    ["17481296528"] = 0.425, -- ShadowSaint
    ["17481286354"] = 0.425, -- LightningSaint
    ["15331452847"] = { -- ElectroCarve
        type = "parry",
        t = {0.725, 0.825, 0.925, 1.025, 1.125, 1.225, 1.325}
    },

    ["18109620534"] = 0.315, -- PleekstyRunCrit
    ["15881820093"] = 0.325, -- FlashFireSweep
    ["17742747596"] = 0.375, -- AerialShotV2
    ["8249177669"] = 0.295, -- RapiersM1x2
    ["12378124969"] = 0.075, -- Ceaseless Slashes
    ["9832727905"] = 0.295, -- Rail-m1x3
    ["9930618934"] = 0.425, -- MusketKick
    ["5953326460"] = 0.425, -- RisingFlame
    ["8467835626"] = 0.475, -- IceForge
    ["8130745441"] = 0.375, -- Knight Swing 1
    ["8230353450"] = { -- Crocco Dig
        type = "dodge",
        t = 0
    },

    ["14435763579"] = 0.305, -- PistolSwing1
    ["8066909599"] = 0.375, -- Revenge
    ["8249271040"] = 0.295, -- RapiersCrit
    ["16394277950"] = 0.475, -- TwisterKicks
    ["133310040571072"] = 0.575, -- MantleAerial
    ["132164383275060"] = 0.375, -- SilentheartMediumRun
    ["18322559443"] = 0.425, -- KyrswinterCrit
    ["6318273143"] = 0.275, -- ShadowAssault
    ["15214200859"] = 0.425, -- RisingThunder
    ["9893133020"] = 0.24, -- RailAirCrit
    ["7599113567"] = 0.475, -- IceDaggers
    ["18441684191"] = 0.775, -- KanaboTripleSmash
    ["8226933122"] = { -- Crocco Triple
        type = "parry",
        t = {0.375, 0.815, 1.255}
    },

    ["13253662736"] = 0.425, -- NeedleBarrage
    ["9629695751"] = 0.525, -- ChampWhirlthrow
    ["9681916972"] = { -- bonekeeper 1
        type = "dodge",
        t = 0.625
    },

    ["6432920452"] = 0.375, -- SecundaryShot
    ["6669352471"] = 0.365, -- GSRunAttack
    ["10258479464"] = 0.675, -- DarksteelCrit
    ["9234812388"] = { -- Iceberg
        type = "parry",
        t = {0.175, 0.375, 0.575, 0.775, 0.975, 1.175, 1.375}
    },

    ["7018046790"] = 0.375, -- Enforcer Swing 1
    ["6675703249"] = 0.315, -- CryptM1x2
    ["13241958217"] = 0.325, -- FirstLightSwing
    ["13242083070"] = 0.325, -- FirstlightSwing2
    ["17116112176"] = 0.345, -- PyreCritRun
    ["8130778356"] = 0.375, -- Knight Swing 2
    ["9681905891"] = 0.775, -- Bonekeeper Charge
    ["11572468462"] = 0.195, -- Mudskipper Swing 2
    ["7391446645"] = 0.625, -- NavaeCrit
    ["12706574441"] = 0.425, -- ProminenceDraw
    ["17665718967"] = 0.245, -- FlameVolley
    ["7019018522"] = { -- Enforcer Spin
        type = "parry",
        t = {0.075, 0.175, 0.275, 0.375, 0.475, 0.575, 0.675, 0.775, 0.875, 0.975, 1.075}
    },

    ["7861127585"] = 0.575, -- ThunderKick
    ["7861135817"] = 0.475, -- ThunderkickV2
    ["7600450739"] = 0.305, -- SwordV2Style
    ["5120461115"] = 0.325, -- ArdourScream
    ["7542502881"] = 0.425, -- FlameLeap
    ["105327179871000"] = 0.425, -- ForgeGreathammerCrit
    ["17363185033"] = 0.425, -- TridentCrit
    ["6017393708"] = 0.325, -- GaleLungeShort
    ["6017418456"] = 0.325, -- GaleLungeFar
    ["9484850093"] = 0.325, -- GranSudaKick
    ["5064195992"] = 0.325, -- GreataxeSwingX1
    ["18967397842"] = { -- EnmityHomerun
        type = "dodge",
        t = 0.625
    },

    ["18967389067"] = { -- EnmityStompSlice
        type = "parry",
        t = {0.725, 2.075}
    },

    ["131597866888761"] = { -- EnmityExecute
        type = "dodge",
        t = 0.775
    },

    ["18966790283"] = { -- EnmityLeftRight
        type = "parry",
        t = {0.825, 2.075}
    },

    ["80841795666744"] = { -- TitusCannonCrit
        type = "dodge",
        t = 1.975
    },

    ["5067105317"] = 0.325, -- GreataxeSwingX2
    ["5067090007"] = 0.325, -- GreataxeSwingX3
    ["7014547998"] = 0.425, -- DragonTail
    ["7014172795"] = { -- DragonSwipe
        type = "parry",
        t = {0.425, 1.075}
    },

    ["9212883524"] = 0.575, -- HalberdCrit
    ["7794260173"] = 0.275, -- RisingWind
    ["9359697890"] = 0.325, -- ShadowDevour
    ["108775350619127"] = 0.325, -- Updraft
    ["109165501462354"] = 0.575, -- KyrsglaiveCritical
    ["7627049402"] = 0, -- spear 1 hand 2
    ["18510057229"] = 0.685, -- SoulthornCrit
    ["7600485223"] = 0.305, -- SwordV2Style2
    ["8379406836"] = 0.375, -- Rapid Slashes
    ["16873988732"] = 0.325, -- JetKick
    ["117160121128317"] = 0.425, -- GreatmaulCrit
    ["102858834757078"] = 0.325, -- KindredEdictSwing
    ["106608030834708"] = 0.325, -- KindredEdictSwingx2
    ["111781160894259"] = 0.325, -- KindredEdictSwingx3
    ["123780310762764"] = 0.325, -- KindredEdictGroundCrit
    ["125807467678893"] = 0.325, -- KindredEdictGroundCritx2
    ["90021911048794"] = 0.325, -- KindredEdictAirCrit
    ["5827250000"] = 0.425, -- SpearRunAttack
    ["125088776029027"] = 0.325, -- RiteOfAuthorityCrit
    ["81791470214091"] = 0.075, -- SlamAuthority
    ["13262891882"] = { -- MetalKick
        type = "dodge",
        t = 0.775
    },

    ["17108040817"] = 0.325, -- GunRunningAttack
    ["5641344204"] = { -- Sharko Grab
        type = "dodge",
        t = 0.175
    },

    ["6432260013"] = { -- Monkey Triple
        type = "parry",
        t = {0.775, 1.525, 2.275, 3.025}
    },

    ["9400896040"] = 0.425, -- ShoulderBash
    ["9710538334"] = { -- Bonekeeper Choke
        type = "dodge",
        t = 0.275
    },

    ["12108376249"] = 0.275, -- EclipseKick
    ["13529982886"] = 0.675, -- MetalIronHug
    ["9422278968"] = 0.875, -- CarbuncleFlail
    ["14954130177"] = 0.175, -- CaltropsV1
    ["126184250609926"] = 0.375, -- IronQuills
    ["13472893499"] = 0.575, -- IronSlam
    ["13643852843"] = 0.375, -- RocketLance
    ["7617742471"] = 0.175, -- Lightning Beam
    ["7600160919"] = 0.315, -- SwordSwing1
    ["9681421310"] = 0.575, -- Bonekeeper Sweep
    ["5117879514"] = 0.325, -- Sharko Swipe
    ["12106091136"] = 0.325, -- Curved X1
    ["16372479940"] = 0.225, -- JusKaritaM1x3
    ["13989464729"] = 0.675, -- GranSudaCrit
    ["17666279427"] = 0.325, -- GuidingStarM1
    ["17666284182"] = 0.325, -- GuidingStarM1x2
    ["17666287806"] = 0.325, -- GuidingStarM1x3
    ["123321475025790"] = 0.425, -- GuidingStarCrit
    ["112381112390648"] = 0.425, -- GuidingStarRunning
    ["92625055798566"] = 0.425, -- GuidingStarAerial
    ["16372422960"] = 0.305, -- PurpledSwing2
    ["18592047703"] = 0.375, -- ChainwardenRupture
    ["9863424290"] = 0.375, -- RailGroundCrit
    ["82111969749817"] = 0.975, -- SilentheartHeavyGap
    ["139465383955578"] = 0.425, -- SilentheartHeavyUpper
    ["17481307114"] = 0.425, -- ArdourSlicer
    ["117058220308511"] = 0.425, -- PleeskySwing2
    ["137978211994071"] = 0.425, -- PleeskySwing1
    ["104616759679357"] = 0.425, -- PleeskySwing3
    ["136701179709286"] = 0.425, -- RedDeathRunCrit
    ["110510943038279"] = 0.625, -- WretchenMawbladesCrit
    ["76842464533258"] = 0.575, -- RedDeathStandCrit
    ["93362023058024"] = 0.375, -- LegionMasteryFlourish
    ["18442438270"] = { -- FlamingScourgeAttempt
        type = "dodge",
        t = 0.525
    },

    ["17665624417"] = 0.075, -- RythmnAdvance
    ["7830946229"] = 0.325, -- ShotelCritical
    ["17665602554"] = 0.175, -- TacetKickV2
    ["18553734325"] = 0.625, -- NocturneCrit
    ["18445833385"] = 1.075, -- KanaboCrit
    ["8085349676"] = 0.425, -- Strong Left
    ["101420289979512"] = 0.425, -- TwinstrikesX1
    ["109488905019243"] = 0.425, -- TwinstrikesX2
    ["8131156119"] = { -- Knight Kick
        type = "dodge",
        t = 0.375
    },

    ["6437665734"] = 0.375, -- PrimaryShot
    ["6675698010"] = 0.315, -- CryptM1
    ["108318311802227"] = 0.425, -- DODGE
    ["80865399851806"] = { -- KickFollowupTitus
        type = "dodge",
        t = 0.275
    },

    ["7827886914"] = 0.425, -- Nemesis Crit
    ["8198492537"] = 0.325, -- ExhaustionStrike
    ["14181029595"] = { -- PrecisionCuts
        type = "parry",
        t = {0.325, 0.675, 1.025, 1.375, 1.725}
    },

    ["14181944470"] = 0.575, -- CloseShave
    ["5063313656"] = 0.325, -- DaggerRunAttack
    ["6607519294"] = 0.375, -- Kanabo3
    ["9501936889"] = 0.775, -- CarbuncleLeap
    ["8198764550"] = 0.135, -- SingxTaunt
    ["6501497627"] = { -- Golem Cyclone
        type = "parry",
        t = {3.575, 3.675}
    },

    ["8172871094"] = { -- KyrseigerCrit
        type = "dodge",
        t = 1.775
    },

    ["16387878472"] = 0.135, -- PurpledCrit
    ["5827423063"] = 0.325, -- SpearRunAttack
    ["5950080662"] = 0.275, -- DaggerM1x4
    ["8375571405"] = { -- PressureBlast
        type = "parry",
        t = {0.575, 0.775, 0.975}
    },

    ["12772036355"] = 0.325, -- Punishment
    ["7639648215"] = 0.325, -- OwlSwipe
    ["18208445321"] = 0.575, -- SpindleCrit
    ["18101585968"] = 0.315, -- PleekstyCrit
    ["8227583745"] = { -- Crocco Double Swipe
        type = "parry",
        t = {0.375, 1.075}
    },

    ["13408478146"] = { -- MetalRain
        type = "dodge",
        t = 0.775
    },

    ["18592050844"] = 0.375, -- ChainwardenRupture2
    ["18319686489"] = { -- KyrswinterRunCrit
        type = "dodge",
        t = 1.375
    },

    ["8249175106"] = 0.295, -- RapierSwing1
    ["8046864635"] = 0.475, -- FireBlade
    ["15121611060"] = 0.425, -- RisingFrost
    ["7627889074"] = 0.195, -- DaggerM1x2
    ["7598898608"] = 0.475, -- IceSmash
    ["130566156191218"] = 0.625, -- DeathReverieCrit
    ["82342705344145"] = 0.325, -- TwinbladeRunAttack
    ["103325425676000"] = 0.425, -- TwinbladeCrit
    ["10053070573"] = 0.425, -- CrescentCrit
    ["11710417615"] = 0.325, -- Sharko Coral
    ["17117274013"] = 0.335, -- PyreCritRunSlash
    ["7600224169"] = 0.315, -- SwordSwing2
    ["13338519421"] = 0.745, -- MetalGatling
    ["16372476897"] = 0.225, -- JustKaritaM1
    ["16961331275"] = 0.425, -- WyrmSlideV2
    ["115289020018430"] = 0.225, -- DreadWhisper
    ["7627854272"] = 0.195, -- DaggerM1
    ["18109641443"] = { -- SoulthornCritV2
        type = "parry",
        t = {0.265, 0.365, 0.465, 0.565, 0.665}
    },

    ["7543558046"] = 0.43, -- FlameAssault
    ["11363599835"] = 0.375, -- HeavyAerialAttack
    ["7794268358"] = 0.325, -- RisingWindCast
    ["16926301301"] = 0.425, -- Fakekick
    ["17197732174"] = 0.255, -- PyreekeperM1x3
    ["17108566269"] = { -- BruteHeavyPunch
        type = "dodge",
        t = 0.575
    },

    ["13529984980"] = 0.275, -- MetalIronHug
    ["16079914008"] = { -- Iceflock
        type = "dodge",
        t = {0.475, 0.675, 0.875, 1.075, 1.275, 1.475, 1.675}
    },

    ["11710290503"] = { -- Sharko Kick
        type = "dodge",
        t = 0.425
    },

    ["6063195211"] = 0.275, -- Karita 3
}

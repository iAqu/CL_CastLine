-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local TitanPath = require(script.Parent:WaitForChild("TitanPath"))
local TitanConfig = require(script.Parent:WaitForChild("TitanConfig"))
local AXIS = TitanPath.AXIS
local t2 = {}

t2.HEAD = Vector3.new(0, 9.2, -45)
t2.CENTRE = Vector3.new(0, 9.2, -5)
t2.LENGTH = 90
t2.BODY = {
    SHIFT = 18,
    LEAN = 12,
    YAW0 = 70,
    SAG = 14,
    LAUNCH = 4,
    ROLL = { 4, 8 },
    SWAY = { 4, 9 },
    YAWJ = { -7, 7 },
    JOLT = {
        PITCH = 3,
        ROLL = 2,
        HZ = 3.2,
        DECAY = 0.18
    },
    SHUDDER = {
        DEG = 0.5,
        HZ = 14,
        DECAY = 0.12
    }
}
t2.LIMB = {
    LEG = {
        LIFT = 0.27,
        LIFT_STEP = 0.01,
        LAND_STEP = 0.02,
        SIDE_STEP = 0.01,
        UP = 26,
        SPREAD = 7,
        OFF = 26,
        REACH = 0.96
    },
    CLAW = {
        AIM = Vector3.new(0.45, -0.55, -0.7),
        HIGH = 12,
        STEP = 6,
        STRIKE = 0.3,
        RIM_IN = 6,
        RIM_Y = 2,
        HOOK = 0.2,
        REACH = 0.95,
        LAND = {
            L = 0.66,
            R = 0.69
        },
        LIFT = {
            L = 0.38,
            R = 0.4
        },
        COCK = {
            IN = 35,
            UP = 40
        }
    },
    FLY = {
        LEG = Vector3.new(0, 12, 22),
        BLEND = 0.3
    }
}

local t3 = {
    (Vector3.new(-69.4, -38.3, -49.9)),
    (Vector3.new(-88.3, -38.4, -19)),
    (Vector3.new(-68.1, -38.3, 22.6)),
    (Vector3.new(-92.1, -38.5, 36)),
    (Vector3.new(-59.1, -37.6, 81.4))
}

local function smooth(p1) -- line: 66
    local v1 = math.clamp(p1, 0, 1)

    return v1 * v1 * (3 - 2 * v1)
end

local function lerp(p2, p3, p4) -- line: 70
    return p2 + (p3 - p2) * p4
end

local function hourOf(p5) -- line: 72
    -- upvalues: TitanConfig (copy)
    return TitanConfig.Seed(p5)
end

local function wallR(p6, p7) -- line: 75
    local v2 = "EDCCCCCCCCCCBBCCCFEEEEECBBBBBBBCCCDCCCCCCCCCCCDDDDDDEDDDDDDDDCDDDEEDDEEEHGEEEEDDDDCCBBDDHKJJIHGCBABAAAAADGIGGGFEFEFFEGIIHHIIIIIJIHHGGFGFGIKIIHHHHFDDCDDCDCBBBABCGIIHLLFCAA@??@@@CGFGFGGFFFGFEGHGFFFFFGGGGJIIIIHFFKPJIHIIIHEDEECCCCBCBABDHNNOPNLEAA@??@@BEFFEEEDDDEDDEFHBA@BCCDCDGNLORLKIFLJIIIIJHHGFFGFEEDDEDDDDILLLMLIEBBBDEGGHLONNMMLLLMMMMHCA@@@DhhhEFPPOPONNNLJHHIIIHGHgghPEEEDDCDDDHKKLLMJCBA@BCEEFIONNMMLLLMMLLIEBAABBCDCFHOONONMMMLKIIIJJHGFFGHFEEEDEDDDFIIHHHHGEEDCDCBBCHNNNMMMLNPQTRMEC@?@@AAAAFOOPONONMLIIJGGJGGLFFFFEEEEEDDDEGHJKKLIBAABAA@@@ELKJJKLKKKJJJJKDAABAACBCGMMMMMMLKKJHGJJJHFEEEEHFGIJKLNIHJJKLKLIDBBBAAABBHONNNNMMMLLLLJHCAABBCCCCHOOOOOONMKIIJGHHGIDCFFHIIIIIIJHHIIIBCDGDCBCBABAAFOUUMNOMNLLLLIF@@??@@@AAFMNNNUUONMIBACCCGLLKLKLLMMLLLLKKIHDCDDHJOIGHHGHHIMMLLLLLJKMLJIFAAA@AAABCILMMNP^SNKICBBCCJJKFFFIMMOTOJGGFILLIJJIFIIIHHFFFHLLMLNNfhgMMKGEA@@@AAAABIOOPQPOONKIIJKKKHGDEEEFFFGGFEDDGKFDDFFHCChhhCAAACHHGGHJJJJHHHHIIKKKJJIIIIIIIIHIGHIJIIIIIKMMMMMMLLLKKKKKLKFCBCDFJKKJJJJIJKMHHHHGGGEEEDHGEGGPHFECDHHGHFFDDEGFFINNJIMMMLMMLKJKJKKKIHFDDEFGIJJIIIIJJKMOOONMMLKKKKHCCBABBBBCCHMNNNNMMLIEDEEEFEFCCCCBCCCCCCCCCDFEFFFECBBBBBBBBCCDCCDCCCCCCCEDDDDCDDDDEEEEDDDCDDFFEEEEEHGEEEEEDDDCDCDCDGKJIIIGCCBBBBAAAEGFFFGFEFDDEEGIIHHHIJIIJJJHGGFFGHKMKIIIJHFDDCCDCCDCCCBCCFHHGLJFBAAAAA??@CFFFFGGFFFEEFGHFFFFFGFFGGJGGGGFHJNeOMKJJIHFDCDDCCECCCDCEILKLRMIEAAAB@@@ADFFEEFFEEEDDDFGBAABBBCDEGMGLLKEFIOMKKJJJJJJIHHHGFEEEEFEEIJJKKJHECCCCCBCEINONMMNMMMLMLHCA@@ABhhhDFOOONNMMMMKIIIIJKLLhggKIGEDEDDDEHJJLLLJBAAAAAABDFNNMMNNMMLLLKHDBBBBBBCCEHOOONNNMLLJIIIJKLLKKLJIHFEEEDDDEHHGGGHGEDCEDCDCBHNNMMMMMMLMRPJCCA@?@@@@AFPPONNMMMLIIIGHKLLOJJGFEEEEECCCDFHKKKLIBAAAA@@@@EKKJJKKJJJJKMLQFDBAABBBBGMLLLKJKKKJHGJJJIGFFEFHEDEJIIGFEIKKKKKICBBBBAAAAGNNNNNMMLLLMNLJDCBAABBBCHOONNNNMNMJIIGHIGIEDEFHEEFFGLHDEHIICEDGDCCCCBAAAGSXWRQOMMMMLMJG@@@@@AAABGNONPUTTNLICBCDEGMLLLKLLKKLLLLLKJHEDDEIMSNMJIHIHJONNNNLMKKNNLHGCBBBBCCDGLPQNOQhQNKHCCBCDJJLFGGJKKKQLGHHGILKIIJIIJJMKIFEEGLLMMNOghhMLKHEA@@@@ADFFMTRPPPOONLIKKKLLHGDDDEFDEGFFDEGINIFEEEHCChhhCAAACHHGHHHIHHHHGGIHHHGHHHIIIIHIIHIIIJJIIHHIHMMMMLMMLLKKKMNONIECCDFJJJJJJJJIKMHGGGGFGFEEEHGDCD]EDDCDHHGGGGEFFHECCKKDHLLLLMMLKJIIJKKKIFEEEFGIIJJJJIJJJMONNNMMLKJJKICBB@ABBBCDGNOONONMMIECDCDDCCCCCCCCCCDDDDEFFFEEEEEDBBBCBBBCCCCCCGFEFFFEFFCCCBBCCCCCCCCCCGFGEEEEDDEECCDDEEDDDDEDFILLLLKLKLKJHDBCCCDCDECDEGNNNNLKJDBCBBCCBCCBCDCBDHMLLMLMLKJFBBBBBBCCCCDDEIMLKKKQRLKJGDBAAACBBBBBCGLLKKJIHDBAAABBAABBCBBABFKKJKJJIIHDFEEEEEEFFFGIMQQOMMMMLLLJIECBCCDDDEEDEGPPOONNKDAAACEGJKJKHFDBBFLKJJIIIJIFGHJONNKHFEFHILONNMMMMLLLHFDDCDDDEQEDEIONNONNKFDCCDFGHMLIGFEDEILMMNLLLLJGFHJVLKIHFFEEEIMMMLMLLLLKGECDCCDCDDCCEHNNMPMMKFDDEEEEEEDEFJFFNJMMLMLMLLKGEDEEDDEEEEEEEJMMMMMMMMLLIGEDDAABBBCCEJOTPONMLKDDEAAAABAABABACGJJIMMIIIHGCCIDBBDBBBCBCHIKKKKKKIIHGKJKJJJKJJKKKJJLLKKJHHBAAAAAA>==>@BABFJJIJJIIHGFKKKJJKLKKKKJJIKHKhhHGEFFGKJJKJKLLNNPOMJGGGFGIMMJIGC@?>=>?@BIIJKGEEEFFFIKKJJKHGHHFFIJKIIEDEEEDDDDFIHHHHHHIKMLLKIHGGGGHLKJJFCA?>>>?ACJJIMLKKJKKKILEDDEEEFFFIPHGJMNNGFEMMNOMIIHDDDCCCCCEIOPOOONKIDEDCCCBBDCDDEDEHKLOVTOMKHJFBIIJKKKKLLJJIJLLMLLLKNPUKIJJIJJHFDDEIMNVgVMJGCBKJHHHJMNOOLKKJJFFFGGGFHKKKJJJJJJJIKJJIGGGGGGGDEFILHNWggRPNLKKKHIJJIIIKJKIIJIHHHHHHIIJLSQHHFELLKKIGGEEEFFFEGFGILMLLLMLLLLJLKKKKKKKJJJJIMOONMMJGDEDDEEFEEFFFEDFJMNNNNSSLJIDDEFFFEFEEECDHMMNMMMLLMLIFDDDDEEEEEEFINNNONNKFCDDDEDEEDCCDCBDGMNNMMMMMJHCBBBBBABBBAACFFFFFFEFFECCBBBBCBBBCCCEFFFFFFFFCBCCABBBBBAABCCDFFEFFFFFFFCBBABBAAAEMMLLLLKKLLLMMJDBBBBBBCCDIMLKIIIIJJJJJGCBBAAA@AGLMLLLKKLLLMMMLJCABAAAAAAFLKJKKKKJJKJJJHCAAABACFJeOPMJILLMMNMMLGBABEDDECFNMLKKKKLLMMMMLICBBBBAAACFKMNNQNNNNNNNMJDA@AAA@BDFJONMLLMMMMMMLIB@AB\\CBBFNPPQRQONLLLMLLICBBBhhhHCGMLLKKLLKLMLLKIECCCCBBBBBHLKKKKKLMNONNJDAAABBA@FNOPQRQPNLLMLLLIDBABBBBABGNNNNMMNNNONNNKDGCCCBCBBBFLMMMLLMOQSWQNDAAAAB@AFMOMMLMMLLLNNLLJCCBBCBBCBGLLKLLNOOOOONMIEDCBGggYEDILMNJIJKJJKKNIEBA@@@?BHMNLKKLLMLLNWNMIECDHDCBCBFHFFFHJLhhgMLIIECCBCCCBCCGIIFFEGGGFGGJGECBCBBABEKJGFFGGGHGHIHHIFBBAAAADCIIGGGHIIHHIIIIIKKJJJJIIIHIIHHFFGFGHGGHMFA@@???BIMMHGGIFEEFFFHIIKKJHHIIJJJKKKIFEFMOQSUMLMKJJJJIJHIIOOLLKKMMMMMMIJIIIHIHGHILMLNNNPOOONNNIKHKIIGHIGIPQROLKLKLNNOPMIDCBHCCCBBGMMNNOQQPOMNMIFELQKIFAFKIHLIII]hggIKIHFBCAABBBDHIHHGFGFGHHHHHHFCBBBCCBACGKJEFGJhhIHGHHCBBBBBAAINJHHHGHIIIIHHHJGKDA@HIJJJIFEEEDDMMNNNFHIBAA@@AA@AHGEFFDFFFFGGFHHIIHGHHFGJGFEEEEEMNNOMNKLLKJIIHHGHNNMMLLLMMMNNMKIJJJJIJJIHHMNNMLLLLKMMMIDCEDCCCCGOONMMMMMNNNPRbeMEGFFEEEFHMNOONNNMNNONNKFCCDDCDDEDFNMMMMMMLMMNMJDCDCDDDCFNNMLLMLKLLLMNNKGACAA@@ABCEFFFFFFFFFFFFDCBBAAAAAABCEFFFFGFFFFEDCA@@@?@@ACCBEGGGFFFFEDECBBDDDCCCCBCIMMMNNNMMNNMLIDCBBBBBBABBGMNNNNNOONKECBCCBBCBABBBGNRRONNNJFEDEDBBBBAAAAAGMMMMNMMMMLLLICBBAAA@@@AAGNMMLLLNMMIDBAAAAAAA@@@FFMMLLLLLIDBABBDDDECCCCDINMMNNNNNNNNMJCBBBBBAAAABGNNMMLOOONJEBABCCCDDBBBHHMLLNNNMIFDDDDDDDDCBCCDJNNNMMNNNNNNMICCHBBBAAAABGMNNNNNOONLECBBCOghJBABGGONNNNNNLEDDDDGIIIIJIHGINMMLMMMMNNNNJCBBBBABAAAAFLNNMMNNNNLHDBBBCCDCBCCHIONMMNNNJFDCCDJJMhhPIHFHOPRRRPONOOONJDDFFMMOGDBBFMNNNNOPONMKEBBCBBCCBACGIOOOONNNLFCDDGFGGGFILJJINNOOONLKKLKKHCDEFHIIGDCCGKLLNQRWSRLGCABA@AAAAIIKINMMMMMMJJJJDEJLJIIJLJJJIFFGGGGFGHGGHJJIJJJJJJIJSOIFGHIIIIJKKIIIHIIIIIJKIHFFFGGHJMKJJJJKJIIIKIIHGEDDEEEEEEFFGIHIJJJIGGGGHKGGSghSIHIJHHHHHHHGHGHJHGFHIKQRMMJJJIDDCCDDDDDIMMNMMNOPRWSQLEDCBCBCBBBCHLNLNOPPONIGCBBCBABBCCCBILNPRSSSMJEEEEDDDBBAAEDJMOPRRTTSSQOLKEBBAABBBAABILLMIHHHIHJKJIHIJHHIIKIHHHHJNh\\JIFCDDEJJJJIIJIIIQHIKM[hNMKHGHJJJJLNOXMLJIIGFFFFFFGIJIHIJIJJDDCDDHGFEFEEGIKJKKJEGEFEEDDDHGEEFGGHHHHFEHEEEEFGGFFDDHOONNNNOONKFDBCEEDDCBCCDHONNNNNNLHEJHEDFDDDCCBCHMMMMMMMMMMMMJDDCDCCDCBCCGNNNMMNNNMIEDCCDCCCDCCCDHONNLMMNJFEFEEAAA@@@@@AEFFFEFFFEEJKICC@@@@@@?@@ADEFFFFFFFFEC@@@@@@@@@@@BFFEFFFFFFD@@A@BBA@@@FMMLLLLLKLMMMNLFCCBCBBAABBFMMLKKLLLLMLLHCBBCBABBBGLJKKKKKJJJKLKKGDAAA@?@DKJIIJJJJJKJJJGDCCCCBBAA@BGLLKKKJKKKLKLGBBBGhhhAAFLMKKNLJJJKKLKKGCA@@@@@ENMMLMLMMNNMNNICAAAAAA@??@FHHHHGGFEGKGGHCABCCBBAAHNNMLLMMMMMMNMMJCEEEDDEJOOOOOMMMMNMNNICAAABABA@@@FKQeJIFEFEFEFHJIJJIHIHGJMLLKLKKMLLKLMMIFFIhhhIKQQRRQOMMMNMNNJCBCCCBBBA@ADIIHHHHGHHHGHIJIIJIHHGGJMNMLLMMMMNMNNNKFGFIIHHKMKJJIIJIJJJJIHHHHLMMIHFDDGGFDDEEEEEEFFHJIIIJPNHHJKLLKJKKKLLLMLLJJDDDC@BGHFFEEFEFFGFFFFEFGHLeHGDAACFFFFFFGGHGGGHGGIJHHEEGJMNMMMMMNMMMMMMJGC@A@@BHJGGFFFFFFEGGGGFDGHCBBCBBBEHGGHJMSSNLKIIIIIIHHHHHKMNMLLLLLLMMNNNKICCBBBCIIFNNNNOOOOONMEFEECCCDCCCCEGEFHIKNVQLKIHJIIJIHIHHJMJIEFGGGGFHJRQKJAAA@@GJNNNNMNNOOPOONMKBABBCBB@@AHHGGGGILIFFFHHJHHGGHGGHHIFGFHHHIHHGIIIJIJIIIHHHHGGGHHGGIMIGGGIJIKJJHHHHIIFEEMKNONNNNNHIKJIHIGHHHMMNNMMMMNNNNNNJKGGDBBBEHFMMMMMNMMMNNLDECGFFFFDCEHNMMMNOONNNNNIDCCECBBCFKTPKMPPPQOMKHHHIHJACCCIJNMMMOUggONNMNMKJJBCBBKdUKIHGHGFFFFFGGMLKBCEBCBIJJKIIKLQTNMJGGFGIKJJReKJKNNMNNOPQPPONMLKJKKJKJKJIIHGFFFFEEFGGHJJKIIJJIJIIHGFFFFHHGGGGGGHHJCBBBCDEEEEEEEEECCCCCCCCCBCCCBCCCDFFEEEEEDDEEECBCCCCCCCDEEEEEEECBCFGGDFECKKJJKKJJJKIJIGECDCCCCCCCEFEDDDDEHKKKLJHGGHMHGEDEILLKLKKKKJJJIGDCDEEEGIKKIJIIIIIIIIHIHFECCCCBCDCCDEDDDCDEHLMMLKHEDDDDECCEHLKKKKKdOKKIHFCDCCCDEGJIKLKJIJIIIKKKJGEBBBDCCDCDDFEPhhUEJMNMLLIEDCDDDDDEILLKLLLKKLKJIECDCDDEFHLKLLKKKKLKKKKJIHFDDDDDEEEEFFEEFEFHJKLKJIGEDCCCCDDEILLLLLLKKLLJIGEFEFEFHJLLLMNMMMNNNLKJIGECDCCDCCDDEFEDDDDEILLKJIHECDCCDDGGILLKKKKLLLKJIGEDDEDEGIKKMOPRggROOMKKJHFFEEEEFFFFLGGGGFFGIKKJJIHHDDCDDDEFJNONNNOONMKKJGEDEEFGHJMLLMMNMMKMJJIJIGGDCCCBBBCCDEDDDCCDGFEKJIHHDCCCDDDEJONNhhPNNMLLNLJFEEFGHJKJDDDCCEGEDDDDEJNMLLLMMNMLLMLLKKJJHECCCDHMLKKKKKKJIGEEEFEEFHFGJGGECBCDEGEDDEDDCCFDDDDEFIQPShhYOOMLLLLLKKKJIEDCCEGMLKKKKKLKIFEEEEEDCFDEHLKJJJJJIGEDDCCDDDFDCDCGGIKKHGGHIGFEHHJJJIHGGKDDDFHXJGHghMFGHKDECDECDGEEIJGGGGFFHPLDNPRSROMMLMLLKHFDEEEFEFFGJOOJHFFFILLLLJIHFDEEEFEHHLLKLLKKJIKJIHFRQQGFHJLLMNOOOMKKKJKKHHNLKKLMMMMLMGFEDCBDGGGDDFIMLLLLLLLKHGEEEEEDCDEEIMKOOONKKIHLMMFEFFDDDKJJJILLJJEIWJKKLLKKKKJIHKMLKIHLMLRMIGFGHJMORTLLKJKIIKKTWKJHGILJHHGGFC:2BCOKHFDBA@229ACCCBBCCBBCEGGHHHFCDCBA=AABDCGG@224>FHFFEDDCBDCDEGD664229:;F<6788443855KJ8444445555555666644;2374133342555z`445676575556555"
    local v4 = math.clamp((p6 - -2100) / 20, 0, 105)
    local v5 = math.deg(p7) % 360 / 5
    local v6 = math.floor(v4)
    local v7 = math.floor(v5)
    local v8 = v4 - v6
    local v9 = v5 - v7
    local v11 = math.min(v6 + 1, 105)
    local v12 = (v7 + 1) % 72
    local v13 = v7 % 72

    local function cell(p8, p9) -- line: 82
        return string.byte("EDCCCCCCCCCCBBCCCFEEEEECBBBBBBBCCCDCCCCCCCCCCCDDDDDDEDDDDDDDDCDDDEEDDEEEHGEEEEDDDDCCBBDDHKJJIHGCBABAAAAADGIGGGFEFEFFEGIIHHIIIIIJIHHGGFGFGIKIIHHHHFDDCDDCDCBBBABCGIIHLLFCAA@??@@@CGFGFGGFFFGFEGHGFFFFFGGGGJIIIIHFFKPJIHIIIHEDEECCCCBCBABDHNNOPNLEAA@??@@BEFFEEEDDDEDDEFHBA@BCCDCDGNLORLKIFLJIIIIJHHGFFGFEEDDEDDDDILLLMLIEBBBDEGGHLONNMMLLLMMMMHCA@@@DhhhEFPPOPONNNLJHHIIIHGHgghPEEEDDCDDDHKKLLMJCBA@BCEEFIONNMMLLLMMLLIEBAABBCDCFHOONONMMMLKIIIJJHGFFGHFEEEDEDDDFIIHHHHGEEDCDCBBCHNNNMMMLNPQTRMEC@?@@AAAAFOOPONONMLIIJGGJGGLFFFFEEEEEDDDEGHJKKLIBAABAA@@@ELKJJKLKKKJJJJKDAABAACBCGMMMMMMLKKJHGJJJHFEEEEHFGIJKLNIHJJKLKLIDBBBAAABBHONNNNMMMLLLLJHCAABBCCCCHOOOOOONMKIIJGHHGIDCFFHIIIIIIJHHIIIBCDGDCBCBABAAFOUUMNOMNLLLLIF@@??@@@AAFMNNNUUONMIBACCCGLLKLKLLMMLLLLKKIHDCDDHJOIGHHGHHIMMLLLLLJKMLJIFAAA@AAABCILMMNP^SNKICBBCCJJKFFFIMMOTOJGGFILLIJJIFIIIHHFFFHLLMLNNfhgMMKGEA@@@AAAABIOOPQPOONKIIJKKKHGDEEEFFFGGFEDDGKFDDFFHCChhhCAAACHHGGHJJJJHHHHIIKKKJJIIIIIIIIHIGHIJIIIIIKMMMMMMLLLKKKKKLKFCBCDFJKKJJJJIJKMHHHHGGGEEEDHGEGGPHFECDHHGHFFDDEGFFINNJIMMMLMMLKJKJKKKIHFDDEFGIJJIIIIJJKMOOONMMLKKKKHCCBABBBBCCHMNNNNMMLIEDEEEFEFCCCCBCCCCCCCCCDFEFFFECBBBBBBBBCCDCCDCCCCCCCEDDDDCDDDDEEEEDDDCDDFFEEEEEHGEEEEEDDDCDCDCDGKJIIIGCCBBBBAAAEGFFFGFEFDDEEGIIHHHIJIIJJJHGGFFGHKMKIIIJHFDDCCDCCDCCCBCCFHHGLJFBAAAAA??@CFFFFGGFFFEEFGHFFFFFGFFGGJGGGGFHJNeOMKJJIHFDCDDCCECCCDCEILKLRMIEAAAB@@@ADFFEEFFEEEDDDFGBAABBBCDEGMGLLKEFIOMKKJJJJJJIHHHGFEEEEFEEIJJKKJHECCCCCBCEINONMMNMMMLMLHCA@@ABhhhDFOOONNMMMMKIIIIJKLLhggKIGEDEDDDEHJJLLLJBAAAAAABDFNNMMNNMMLLLKHDBBBBBBCCEHOOONNNMLLJIIIJKLLKKLJIHFEEEDDDEHHGGGHGEDCEDCDCBHNNMMMMMMLMRPJCCA@?@@@@AFPPONNMMMLIIIGHKLLOJJGFEEEEECCCDFHKKKLIBAAAA@@@@EKKJJKKJJJJKMLQFDBAABBBBGMLLLKJKKKJHGJJJIGFFEFHEDEJIIGFEIKKKKKICBBBBAAAAGNNNNNMMLLLMNLJDCBAABBBCHOONNNNMNMJIIGHIGIEDEFHEEFFGLHDEHIICEDGDCCCCBAAAGSXWRQOMMMMLMJG@@@@@AAABGNONPUTTNLICBCDEGMLLLKLLKKLLLLLKJHEDDEIMSNMJIHIHJONNNNLMKKNNLHGCBBBBCCDGLPQNOQhQNKHCCBCDJJLFGGJKKKQLGHHGILKIIJIIJJMKIFEEGLLMMNOghhMLKHEA@@@@ADFFMTRPPPOONLIKKKLLHGDDDEFDEGFFDEGINIFEEEHCChhhCAAACHHGHHHIHHHHGGIHHHGHHHIIIIHIIHIIIJJIIHHIHMMMMLMMLLKKKMNONIECCDFJJJJJJJJIKMHGGGGFGFEEEHGDCD]EDDCDHHGGGGEFFHECCKKDHLLLLMMLKJIIJKKKIFEEEFGIIJJJJIJJJMONNNMMLKJJKICBB@ABBBCDGNOONONMMIECDCDDCCCCCCCCCCDDDDEFFFEEEEEDBBBCBBBCCCCCCGFEFFFEFFCCCBBCCCCCCCCCCGFGEEEEDDEECCDDEEDDDDEDFILLLLKLKLKJHDBCCCDCDECDEGNNNNLKJDBCBBCCBCCBCDCBDHMLLMLMLKJFBBBBBBCCCCDDEIMLKKKQRLKJGDBAAACBBBBBCGLLKKJIHDBAAABBAABBCBBABFKKJKJJIIHDFEEEEEEFFFGIMQQOMMMMLLLJIECBCCDDDEEDEGPPOONNKDAAACEGJKJKHFDBBFLKJJIIIJIFGHJONNKHFEFHILONNMMMMLLLHFDDCDDDEQEDEIONNONNKFDCCDFGHMLIGFEDEILMMNLLLLJGFHJVLKIHFFEEEIMMMLMLLLLKGECDCCDCDDCCEHNNMPMMKFDDEEEEEEDEFJFFNJMMLMLMLLKGEDEEDDEEEEEEEJMMMMMMMMLLIGEDDAABBBCCEJOTPONMLKDDEAAAABAABABACGJJIMMIIIHGCCIDBBDBBBCBCHIKKKKKKIIHGKJKJJJKJJKKKJJLLKKJHHBAAAAAA>==>@BABFJJIJJIIHGFKKKJJKLKKKKJJIKHKhhHGEFFGKJJKJKLLNNPOMJGGGFGIMMJIGC@?>=>?@BIIJKGEEEFFFIKKJJKHGHHFFIJKIIEDEEEDDDDFIHHHHHHIKMLLKIHGGGGHLKJJFCA?>>>?ACJJIMLKKJKKKILEDDEEEFFFIPHGJMNNGFEMMNOMIIHDDDCCCCCEIOPOOONKIDEDCCCBBDCDDEDEHKLOVTOMKHJFBIIJKKKKLLJJIJLLMLLLKNPUKIJJIJJHFDDEIMNVgVMJGCBKJHHHJMNOOLKKJJFFFGGGFHKKKJJJJJJJIKJJIGGGGGGGDEFILHNWggRPNLKKKHIJJIIIKJKIIJIHHHHHHIIJLSQHHFELLKKIGGEEEFFFEGFGILMLLLMLLLLJLKKKKKKKJJJJIMOONMMJGDEDDEEFEEFFFEDFJMNNNNSSLJIDDEFFFEFEEECDHMMNMMMLLMLIFDDDDEEEEEEFINNNONNKFCDDDEDEEDCCDCBDGMNNMMMMMJHCBBBBBABBBAACFFFFFFEFFECCBBBBCBBBCCCEFFFFFFFFCBCCABBBBBAABCCDFFEFFFFFFFCBBABBAAAEMMLLLLKKLLLMMJDBBBBBBCCDIMLKIIIIJJJJJGCBBAAA@AGLMLLLKKLLLMMMLJCABAAAAAAFLKJKKKKJJKJJJHCAAABACFJeOPMJILLMMNMMLGBABEDDECFNMLKKKKLLMMMMLICBBBBAAACFKMNNQNNNNNNNMJDA@AAA@BDFJONMLLMMMMMMLIB@AB\\CBBFNPPQRQONLLLMLLICBBBhhhHCGMLLKKLLKLMLLKIECCCCBBBBBHLKKKKKLMNONNJDAAABBA@FNOPQRQPNLLMLLLIDBABBBBABGNNNNMMNNNONNNKDGCCCBCBBBFLMMMLLMOQSWQNDAAAAB@AFMOMMLMMLLLNNLLJCCBBCBBCBGLLKLLNOOOOONMIEDCBGggYEDILMNJIJKJJKKNIEBA@@@?BHMNLKKLLMLLNWNMIECDHDCBCBFHFFFHJLhhgMLIIECCBCCCBCCGIIFFEGGGFGGJGECBCBBABEKJGFFGGGHGHIHHIFBBAAAADCIIGGGHIIHHIIIIIKKJJJJIIIHIIHHFFGFGHGGHMFA@@???BIMMHGGIFEEFFFHIIKKJHHIIJJJKKKIFEFMOQSUMLMKJJJJIJHIIOOLLKKMMMMMMIJIIIHIHGHILMLNNNPOOONNNIKHKIIGHIGIPQROLKLKLNNOPMIDCBHCCCBBGMMNNOQQPOMNMIFELQKIFAFKIHLIII]hggIKIHFBCAABBBDHIHHGFGFGHHHHHHFCBBBCCBACGKJEFGJhhIHGHHCBBBBBAAINJHHHGHIIIIHHHJGKDA@HIJJJIFEEEDDMMNNNFHIBAA@@AA@AHGEFFDFFFFGGFHHIIHGHHFGJGFEEEEEMNNOMNKLLKJIIHHGHNNMMLLLMMMNNMKIJJJJIJJIHHMNNMLLLLKMMMIDCEDCCCCGOONMMMMMNNNPRbeMEGFFEEEFHMNOONNNMNNONNKFCCDDCDDEDFNMMMMMMLMMNMJDCDCDDDCFNNMLLMLKLLLMNNKGACAA@@ABCEFFFFFFFFFFFFDCBBAAAAAABCEFFFFGFFFFEDCA@@@?@@ACCBEGGGFFFFEDECBBDDDCCCCBCIMMMNNNMMNNMLIDCBBBBBBABBGMNNNNNOONKECBCCBBCBABBBGNRRONNNJFEDEDBBBBAAAAAGMMMMNMMMMLLLICBBAAA@@@AAGNMMLLLNMMIDBAAAAAAA@@@FFMMLLLLLIDBABBDDDECCCCDINMMNNNNNNNNMJCBBBBBAAAABGNNMMLOOONJEBABCCCDDBBBHHMLLNNNMIFDDDDDDDDCBCCDJNNNMMNNNNNNMICCHBBBAAAABGMNNNNNOONLECBBCOghJBABGGONNNNNNLEDDDDGIIIIJIHGINMMLMMMMNNNNJCBBBBABAAAAFLNNMMNNNNLHDBBBCCDCBCCHIONMMNNNJFDCCDJJMhhPIHFHOPRRRPONOOONJDDFFMMOGDBBFMNNNNOPONMKEBBCBBCCBACGIOOOONNNLFCDDGFGGGFILJJINNOOONLKKLKKHCDEFHIIGDCCGKLLNQRWSRLGCABA@AAAAIIKINMMMMMMJJJJDEJLJIIJLJJJIFFGGGGFGHGGHJJIJJJJJJIJSOIFGHIIIIJKKIIIHIIIIIJKIHFFFGGHJMKJJJJKJIIIKIIHGEDDEEEEEEFFGIHIJJJIGGGGHKGGSghSIHIJHHHHHHHGHGHJHGFHIKQRMMJJJIDDCCDDDDDIMMNMMNOPRWSQLEDCBCBCBBBCHLNLNOPPONIGCBBCBABBCCCBILNPRSSSMJEEEEDDDBBAAEDJMOPRRTTSSQOLKEBBAABBBAABILLMIHHHIHJKJIHIJHHIIKIHHHHJNh\\JIFCDDEJJJJIIJIIIQHIKM[hNMKHGHJJJJLNOXMLJIIGFFFFFFGIJIHIJIJJDDCDDHGFEFEEGIKJKKJEGEFEEDDDHGEEFGGHHHHFEHEEEEFGGFFDDHOONNNNOONKFDBCEEDDCBCCDHONNNNNNLHEJHEDFDDDCCBCHMMMMMMMMMMMMJDDCDCCDCBCCGNNNMMNNNMIEDCCDCCCDCCCDHONNLMMNJFEFEEAAA@@@@@AEFFFEFFFEEJKICC@@@@@@?@@ADEFFFFFFFFEC@@@@@@@@@@@BFFEFFFFFFD@@A@BBA@@@FMMLLLLLKLMMMNLFCCBCBBAABBFMMLKKLLLLMLLHCBBCBABBBGLJKKKKKJJJKLKKGDAAA@?@DKJIIJJJJJKJJJGDCCCCBBAA@BGLLKKKJKKKLKLGBBBGhhhAAFLMKKNLJJJKKLKKGCA@@@@@ENMMLMLMMNNMNNICAAAAAA@??@FHHHHGGFEGKGGHCABCCBBAAHNNMLLMMMMMMNMMJCEEEDDEJOOOOOMMMMNMNNICAAABABA@@@FKQeJIFEFEFEFHJIJJIHIHGJMLLKLKKMLLKLMMIFFIhhhIKQQRRQOMMMNMNNJCBCCCBBBA@ADIIHHHHGHHHGHIJIIJIHHGGJMNMLLMMMMNMNNNKFGFIIHHKMKJJIIJIJJJJIHHHHLMMIHFDDGGFDDEEEEEEFFHJIIIJPNHHJKLLKJKKKLLLMLLJJDDDC@BGHFFEEFEFFGFFFFEFGHLeHGDAACFFFFFFGGHGGGHGGIJHHEEGJMNMMMMMNMMMMMMJGC@A@@BHJGGFFFFFFEGGGGFDGHCBBCBBBEHGGHJMSSNLKIIIIIIHHHHHKMNMLLLLLLMMNNNKICCBBBCIIFNNNNOOOOONMEFEECCCDCCCCEGEFHIKNVQLKIHJIIJIHIHHJMJIEFGGGGFHJRQKJAAA@@GJNNNNMNNOOPOONMKBABBCBB@@AHHGGGGILIFFFHHJHHGGHGGHHIFGFHHHIHHGIIIJIJIIIHHHHGGGHHGGIMIGGGIJIKJJHHHHIIFEEMKNONNNNNHIKJIHIGHHHMMNNMMMMNNNNNNJKGGDBBBEHFMMMMMNMMMNNLDECGFFFFDCEHNMMMNOONNNNNIDCCECBBCFKTPKMPPPQOMKHHHIHJACCCIJNMMMOUggONNMNMKJJBCBBKdUKIHGHGFFFFFGGMLKBCEBCBIJJKIIKLQTNMJGGFGIKJJReKJKNNMNNOPQPPONMLKJKKJKJKJIIHGFFFFEEFGGHJJKIIJJIJIIHGFFFFHHGGGGGGHHJCBBBCDEEEEEEEEECCCCCCCCCBCCCBCCCDFFEEEEEDDEEECBCCCCCCCDEEEEEEECBCFGGDFECKKJJKKJJJKIJIGECDCCCCCCCEFEDDDDEHKKKLJHGGHMHGEDEILLKLKKKKJJJIGDCDEEEGIKKIJIIIIIIIIHIHFECCCCBCDCCDEDDDCDEHLMMLKHEDDDDECCEHLKKKKKdOKKIHFCDCCCDEGJIKLKJIJIIIKKKJGEBBBDCCDCDDFEPhhUEJMNMLLIEDCDDDDDEILLKLLLKKLKJIECDCDDEFHLKLLKKKKLKKKKJIHFDDDDDEEEEFFEEFEFHJKLKJIGEDCCCCDDEILLLLLLKKLLJIGEFEFEFHJLLLMNMMMNNNLKJIGECDCCDCCDDEFEDDDDEILLKJIHECDCCDDGGILLKKKKLLLKJIGEDDEDEGIKKMOPRggROOMKKJHFFEEEEFFFFLGGGGFFGIKKJJIHHDDCDDDEFJNONNNOONMKKJGEDEEFGHJMLLMMNMMKMJJIJIGGDCCCBBBCCDEDDDCCDGFEKJIHHDCCCDDDEJONNhhPNNMLLNLJFEEFGHJKJDDDCCEGEDDDDEJNMLLLMMNMLLMLLKKJJHECCCDHMLKKKKKKJIGEEEFEEFHFGJGGECBCDEGEDDEDDCCFDDDDEFIQPShhYOOMLLLLLKKKJIEDCCEGMLKKKKKLKIFEEEEEDCFDEHLKJJJJJIGEDDCCDDDFDCDCGGIKKHGGHIGFEHHJJJIHGGKDDDFHXJGHghMFGHKDECDECDGEEIJGGGGFFHPLDNPRSROMMLMLLKHFDEEEFEFFGJOOJHFFFILLLLJIHFDEEEFEHHLLKLLKKJIKJIHFRQQGFHJLLMNOOOMKKKJKKHHNLKKLMMMMLMGFEDCBDGGGDDFIMLLLLLLLKHGEEEEEDCDEEIMKOOONKKIHLMMFEFFDDDKJJJILLJJEIWJKKLLKKKKJIHKMLKIHLMLRMIGFGHJMORTLLKJKIIKKTWKJHGILJHHGGFC:2BCOKHFDBA@229ACCCBBCCBBCEGGHHHFCDCBA=AABDCGG@224>FHFFEDDCBDCDEGD664229:;F<6788443855KJ8444445555555666644;2374133342555z`445676575556555", p8 * 72 + p9 + 1) - 33 + 50
    end

    local v16 = string.byte(v2, v6 * 72 + v13 + 1) - 33 + 50
    local v18 = v16 + (string.byte(v2, v6 * 72 + v12 + 1) - 33 + 50 - v16) * v9
    local v20 = string.byte(v2, v11 * 72 + v13 + 1) - 33 + 50

    return v18 + (v20 + (string.byte(v2, v11 * 72 + v12 + 1) - 33 + 50 - v20) * v9 - v18) * v8
end

t2.WallR = wallR

local function toWall(p10, p11) -- line: 87
    -- upvalues: AXIS (copy), wallR (copy)
    local v22 = p10.X - AXIS.X
    local v23 = p10.Z - AXIS.Z
    local v24 = p11.X * p11.X + p11.Z * p11.Z

    if v24 < 1E-06 then
        return nil
    end

    local v25 = 2 * (p11.X * v22 + p11.Z * v23)
    local n1 = 88
    local v26

    for _ = 1, 3 do
        local v27 = v25 * v25 - 4 * v24 * (v22 * v22 + v23 * v23 - n1 * n1)

        if v27 < 0 then
            return nil
        end

        v26 = p10 + p11 * ((-v25 + math.sqrt(v27)) / (2 * v24))
        n1 = wallR(v26.Y, (math.atan2(v26.Z - AXIS.Z, v26.X - AXIS.X)))
    end

    return v26
end

local function boundPose(p12, p13, p14) -- line: 105
    -- upvalues: TitanConfig (copy), t2 (copy)
    if p14 < 0 or p13.C.BOUNDS - 1 <= p14 then
        return 0, 0, 0
    end

    local BODY = t2.BODY
    local v30 = Random.new(TitanConfig.Seed(p12) * 7919 + p14 * 131 + 3)
    local v31 = if p14 % 2 == 0 then 1 else -1
    local v32 = BODY.ROLL[1]
    local v33 = BODY.ROLL[2]
    local v34 = v30:NextNumber()
    local v35 = v31 * (v32 + (v33 - v32) * v34)
    local v36 = BODY.SWAY[1]
    local v37 = BODY.SWAY[2]
    local v38 = v30:NextNumber()
    local v39 = v31 * (v36 + (v37 - v36) * v38)
    local v40 = BODY.YAWJ[1]
    local v41 = BODY.YAWJ[2]
    local v42 = v30:NextNumber()

    return v35, v39, v40 + (v41 - v40) * v42
end

local function climbFrame(p15, p16, p17, p18, p19) -- line: 114
    -- upvalues: TitanPath (copy), t2 (copy), boundPose (copy)
    local C = p16.C
    local BODY = t2.BODY
    local v43 = C.FROM + p17 / p16.T
    local v44 = math.floor(v43)
    local v45 = v43 - v44
    local v46 = 0

    if p16.XE < p17 then
        local v48 = math.clamp((p17 - p16.XE) / p16.E, 0, 1)

        v46 = v48 * v48 * (3 - 2 * v48) or 0
    end

    local v49, v50, v51 = boundPose(p15, p16, v44 - 1)
    local v52, v53, v54 = boundPose(p15, p16, v44)
    local v56 = math.clamp((v45 - 0.3) / (C.CATCH + 0.02 - 0.3), 0, 1)
    local v57 = v56 * v56 * (3 - 2 * v56)
    local v58 = v49 + (v52 - v49) * v57
    local v59 = v50 + (v53 - v50) * v57
    local v60 = v51 + (v54 - v51) * v57
    local v61 = C.BOUNDS - 1 + C.CATCH
    local YAW0 = BODY.YAW0
    local v63 = math.clamp((v43 - C.FROM) / (v61 - C.FROM), 0, 1)
    local v64 = v60 + YAW0 * (1 - v63 * v63 * (3 - 2 * v63))
    local n2 = 0

    if C.CATCH <= v45 then
        n2 = 1 - (1 - math.min((v45 - C.CATCH) / 0.14, 1)) ^ 3
    elseif v44 >= 1 then
        if v45 < 0.22 then
            n2 = 1
        else
            local v67 = math.clamp((v45 - 0.22) / 0.14, 0, 1)

            n2 = 1 - v67 * v67 * (3 - 2 * v67)
        end
    end

    local v68 = n2 * (1 - v46)
    local v69, v70

    if C.CATCH <= v45 then
        local v71 = (v45 - C.CATCH) * p16.T

        if v71 then
            v69 = v71
            v70 = true
        elseif v44 >= 1 then
            local v72 = (v45 + 1 - C.CATCH) * p16.T

            if v72 then
                v69 = v72
                v70 = true
            else
                v70 = false
            end
        else
            v70 = false
        end
    elseif v44 >= 1 then
        local v73 = (v45 + 1 - C.CATCH) * p16.T

        if v73 then
            v69 = v73
            v70 = true
        else
            v70 = false
        end
    else
        v70 = false
    end

    if not v70 then
        v69 = nil
    end

    local v74 = BODY.LEAN * (1 - v46)
    local v75, v76

    if v69 then
        local JOLT, SHUDDER = BODY.JOLT, BODY.SHUDDER
        local v80 = math.exp(-v69 / JOLT.DECAY) * math.sin(6.283185307179586 * JOLT.HZ * v69)
        local v84 = math.exp(-v69 / SHUDDER.DECAY) * math.sin(6.283185307179586 * SHUDDER.HZ * v69) * SHUDDER.DEG

        v75 = v74 + (JOLT.PITCH * v80 + v84)
        v76 = JOLT.ROLL * v80 * (if v44 % 2 == 0 then 1 else -1) + v84
    else
        v75 = v74
        v76 = 0
    end

    if v45 > 0.26 and v45 < 0.6 then
        v75 -= BODY.LAUNCH * math.sin(3.141592653589793 * (v45 - 0.26) / 0.34)
    end

    local v86 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(v64))):VectorToWorldSpace(p19)
    local v89 = CFrame.fromMatrix(Vector3.new(0, 0, 0), v86:Cross((Vector3.new(0, 1, 0))), -v86) * CFrame.Angles(-math.rad(v75), 0, 0) * CFrame.Angles(0, 0, (math.rad(v58 + v76)))
    local v90 = TitanPath.At(p15, p18, p19) - Vector3.new(0, 1, 0) * (t2.HEAD - t2.CENTRE).Magnitude + v86 * (BODY.SHIFT * (1 - v46)) + v86:Cross((Vector3.new(0, 1, 0))) * v59 - Vector3.new(0, 1, 0) * (BODY.SAG * v68)

    return CFrame.new(v90) * v89 * CFrame.new(-t2.CENTRE), v89.LookVector
end

local v91 = CFrame.Angles(0, 0, 3.141592653589793)

local function pathFrame(p20, p21, p22) -- line: 157
    -- upvalues: TitanPath (copy), t2 (copy), v91 (copy)
    local v92, v93, v94 = TitanPath.At(p20, p21, p22)
    local Unit = (v94 - v93 * v94:Dot(v93)).Unit
    local v95 = CFrame.fromMatrix(Vector3.new(0, 0, 0), Unit, (-v93):Cross(Unit)) * v91

    return CFrame.new(v92) * v95 * CFrame.new(-t2.HEAD), v93
end

t2.ARENA = {
    STAND = 40,
    SMOOTH = 10,
    ROUND = 40,
    STEP = 4,
    GROUND = -4060,
    LO_Y = -4112,
    HI_Y = -3830,
    RAMP = 0.16,
    STOP = 0.1,
    DIAG = 60,
    TURN = 0.4,
    CYCLE = 64,
    STANCE = 0.5,
    LIFT = 14,
    BOB = 2.5,
    LEAN = 9,
    SPAN = 330,
    BAND = { -4080, -4020 },
    PILLAR = {
        NEAR = 10,
        FAR = 20,
        GROUND_IN = 40
    },
    SPEED = { 200, 320 },
    RUN = { 0.6, 2 },
    FREEZE = { 0.3, 1.3 },
    GOALS = {
        { "inner", 45, -4112, -4078 },
        { "ground", 25, -4061, -4026 },
        { "wall", 30, -4005, -3830 }
    },
    JUMP = {
        CHANCE = 0.22,
        BASE = 0.55,
        SPEED = 450,
        MIN = 0.9,
        MAX = 2,
        ARC_K = 0.15,
        CLEAR = 90,
        TOP = -3990,
        CEIL = -3790,
        LAND = 0.35,
        OFF = 0.25,
        REACH = 0.7,
        TURN = { 50, 140 },
        ARC = { 60, 160 }
    },
    TWITCH = {
        DEG = 4,
        HZ = 9
    },
    PEEK = {
        CHANCE = 0.3,
        UP = 18,
        RISE = 0.22,
        HOLD = 1.3,
        STRIKES = 2,
        GAP = 0.32,
        ROAR = 0.5,
        PITCH = 6
    },
    CLAW = {
        SWING = 0.26,
        AHEAD = 45,
        IN = 30,
        BACK = 0.25
    },
    EMERGE = {
        FLOOR = -4250,
        TOP = -4165,
        HAUL = 0.5,
        UP = 70,
        REGRAB = 0.8,
        FLING = 0.4,
        FLY = 1,
        WALL = -3950,
        ARC = 120
    },
    SHAKE = {
        DEG = 28,
        HZ = 2.6
    }
}

local ARENA = t2.ARENA
local v96 = Vector3.new(TitanPath.CAVE.CENTRE.X, 0, TitanPath.CAVE.CENTRE.Z)

local function caveR(p23, p24) -- line: 212
    local v98 = math.clamp((p23 - -4300) / 20, 1, 30)
    local v99 = math.deg(p24) % 360 / 5
    local v100 = math.floor(v98)
    local v101 = math.floor(v99)
    local v102 = v98 - v100
    local v103 = v99 - v101
    local v105 = math.min(v100 + 1, 30)
    local v106 = (v101 + 1) % 72
    local v107 = v101 % 72

    local function cell(p25, p26) -- line: 220
        return (string.byte("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&&&%&&%&&&&&%&&&&&&&&%&&%&&&&&%&&%&&&&&%&&%&&%&&&&&&&&&&&&&&&&&&&&&&&%&&((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((************************************************************************,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,...............-................................................-........//..)+/0.//./-.000././/0//.//+,/0000//.0101,.//.//.//.//.000//0-..0.,1/SZTMKN1IVZVBHdQMNPQ@GScPPLOOAK-.ANNSUTIT_ha^OQXQEGKWXSTUROT\\@EXZ6XLNX0PT[[VOPOLLWe[ZXTQM\\VRFGXdTPKPOLN`dVOMYWTQT_idbQS\\SPHLZ[RSVROTdCFY\\[\\\\`[TUT\\\\XSQOKMXfjabWQM_XSPNbfWPLQQKNad]PNVXTQT^jecWV^VRHN]gSSWRNTfYV[]`W_adZYW]]c]RQJNYgkbbYRMaUTgnlgYQMQSJObd_QOTYURT^kfe`\\_XTIO_gTRXTNVgZW\\^YY`ae[XY^^g^TSINZhhccZSMdWUhonhZLMRUJObd`SPSZVST^lgga^`ZVIQ`hUSZUNVg[X\\^ZZabf[XZ__h_VUIO[qidd\\OMgXWhpoj\\MNRVJPbdbURT[WST]lhhc_b\\XISbjVS[VOWh]Z\\_\\\\bch\\X\\`aiaWVJP\\qjee\\PNiYYipqk\\MOSWKPbdcWTT\\WTT]liidac_ZKTdkXT]XQWh^[]`\\\\\\dj\\X\\abkcYXKP]ekfe]QN\\[[iqsn]MOTWLQbdeYUV]XUU]lkjebea\\LVfmYU^YSXh_\\]`]]]ek]]]bdldZYKQ^flgf^SP_]^jqrp^NPTXMQbdg[WX_XVW]llkgcgc^NXgoZW`[UXh`]^]^^^fm]^^cenf\\\\LR^gmhgaTQadfjrsraOQUZOQbej]XZcYXX]lmlheje`OZiq[Xa\\XYha^_]aaahn^aadfoh]]MR_jmihbUScefkoutbPRV\\PRbek_Z]j`Y[`lnmifhhbQ[kh\\Zc]ZYhb``^bbbip^bbehpj__NS_knjicWVfcglpwucQRW]QRbela\\enaZ^clpnkhikdS]mc][e_\\Zicab_ccckr_ccgiqka`PT`kokjeYXhehlqyweTSX]SSbflc]gqb[^ckqpljjpfV_ne_]f`_Zjdbe`eeelsaeehkrmbbRTalplke\\[keimq{yexUX^UScfmd_itd\\^ckrqnkeuiYaie`_hba]kecbceeenuceejlsoddUUblqmlf^]mfknr}{fzVY_VTegofamye\\_ckssomfff[bkfaaicc_mfedffffowdffgmpqefWVbmrnmg``oglogggg|WZ`XVdgrhcpgf]_dltsqnggg^dmgcckedbngfghgggqhfgghohtghZXchhohhcbhhmphhhh~X[`ZXdirkethh^_dlvusphhh_fnhcfmfeephgikhhhtzihhjpjzik\\[djjpjjfejjjjjjjjjY[a[Zelsphjjjb_dlwxtqjjjahjjjyphgjujjknjjjwjjjj", p25 * 72 + p26 + 1) - 33) * 4 + 280
    end

    local v110 = (string.byte("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&&&%&&%&&&&&%&&&&&&&&%&&%&&&&&%&&%&&&&&%&&%&&%&&&&&&&&&&&&&&&&&&&&&&&%&&((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((************************************************************************,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,...............-................................................-........//..)+/0.//./-.000././/0//.//+,/0000//.0101,.//.//.//.//.000//0-..0.,1/SZTMKN1IVZVBHdQMNPQ@GScPPLOOAK-.ANNSUTIT_ha^OQXQEGKWXSTUROT\\@EXZ6XLNX0PT[[VOPOLLWe[ZXTQM\\VRFGXdTPKPOLN`dVOMYWTQT_idbQS\\SPHLZ[RSVROTdCFY\\[\\\\`[TUT\\\\XSQOKMXfjabWQM_XSPNbfWPLQQKNad]PNVXTQT^jecWV^VRHN]gSSWRNTfYV[]`W_adZYW]]c]RQJNYgkbbYRMaUTgnlgYQMQSJObd_QOTYURT^kfe`\\_XTIO_gTRXTNVgZW\\^YY`ae[XY^^g^TSINZhhccZSMdWUhonhZLMRUJObd`SPSZVST^lgga^`ZVIQ`hUSZUNVg[X\\^ZZabf[XZ__h_VUIO[qidd\\OMgXWhpoj\\MNRVJPbdbURT[WST]lhhc_b\\XISbjVS[VOWh]Z\\_\\\\bch\\X\\`aiaWVJP\\qjee\\PNiYYipqk\\MOSWKPbdcWTT\\WTT]liidac_ZKTdkXT]XQWh^[]`\\\\\\dj\\X\\abkcYXKP]ekfe]QN\\[[iqsn]MOTWLQbdeYUV]XUU]lkjebea\\LVfmYU^YSXh_\\]`]]]ek]]]bdldZYKQ^flgf^SP_]^jqrp^NPTXMQbdg[WX_XVW]llkgcgc^NXgoZW`[UXh`]^]^^^fm]^^cenf\\\\LR^gmhgaTQadfjrsraOQUZOQbej]XZcYXX]lmlheje`OZiq[Xa\\XYha^_]aaahn^aadfoh]]MR_jmihbUScefkoutbPRV\\PRbek_Z]j`Y[`lnmifhhbQ[kh\\Zc]ZYhb``^bbbip^bbehpj__NS_knjicWVfcglpwucQRW]QRbela\\enaZ^clpnkhikdS]mc][e_\\Zicab_ccckr_ccgiqka`PT`kokjeYXhehlqyweTSX]SSbflc]gqb[^ckqpljjpfV_ne_]f`_Zjdbe`eeelsaeehkrmbbRTalplke\\[keimq{yexUX^UScfmd_itd\\^ckrqnkeuiYaie`_hba]kecbceeenuceejlsoddUUblqmlf^]mfknr}{fzVY_VTegofamye\\_ckssomfff[bkfaaicc_mfedffffowdffgmpqefWVbmrnmg``oglogggg|WZ`XVdgrhcpgf]_dltsqnggg^dmgcckedbngfghgggqhfgghohtghZXchhohhcbhhmphhhh~X[`ZXdirkethh^_dlvusphhh_fnhcfmfeephgikhhhtzihhjpjzik\\[djjpjjfejjjjjjjjjY[a[Zelsphjjjb_dlwxtqjjjahjjjyphgjujjknjjjwjjjj", v100 * 72 + v107 + 1) - 33) * 4 + 280
    local v112 = v110 + ((string.byte("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&&&%&&%&&&&&%&&&&&&&&%&&%&&&&&%&&%&&&&&%&&%&&%&&&&&&&&&&&&&&&&&&&&&&&%&&((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((************************************************************************,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,...............-................................................-........//..)+/0.//./-.000././/0//.//+,/0000//.0101,.//.//.//.//.000//0-..0.,1/SZTMKN1IVZVBHdQMNPQ@GScPPLOOAK-.ANNSUTIT_ha^OQXQEGKWXSTUROT\\@EXZ6XLNX0PT[[VOPOLLWe[ZXTQM\\VRFGXdTPKPOLN`dVOMYWTQT_idbQS\\SPHLZ[RSVROTdCFY\\[\\\\`[TUT\\\\XSQOKMXfjabWQM_XSPNbfWPLQQKNad]PNVXTQT^jecWV^VRHN]gSSWRNTfYV[]`W_adZYW]]c]RQJNYgkbbYRMaUTgnlgYQMQSJObd_QOTYURT^kfe`\\_XTIO_gTRXTNVgZW\\^YY`ae[XY^^g^TSINZhhccZSMdWUhonhZLMRUJObd`SPSZVST^lgga^`ZVIQ`hUSZUNVg[X\\^ZZabf[XZ__h_VUIO[qidd\\OMgXWhpoj\\MNRVJPbdbURT[WST]lhhc_b\\XISbjVS[VOWh]Z\\_\\\\bch\\X\\`aiaWVJP\\qjee\\PNiYYipqk\\MOSWKPbdcWTT\\WTT]liidac_ZKTdkXT]XQWh^[]`\\\\\\dj\\X\\abkcYXKP]ekfe]QN\\[[iqsn]MOTWLQbdeYUV]XUU]lkjebea\\LVfmYU^YSXh_\\]`]]]ek]]]bdldZYKQ^flgf^SP_]^jqrp^NPTXMQbdg[WX_XVW]llkgcgc^NXgoZW`[UXh`]^]^^^fm]^^cenf\\\\LR^gmhgaTQadfjrsraOQUZOQbej]XZcYXX]lmlheje`OZiq[Xa\\XYha^_]aaahn^aadfoh]]MR_jmihbUScefkoutbPRV\\PRbek_Z]j`Y[`lnmifhhbQ[kh\\Zc]ZYhb``^bbbip^bbehpj__NS_knjicWVfcglpwucQRW]QRbela\\enaZ^clpnkhikdS]mc][e_\\Zicab_ccckr_ccgiqka`PT`kokjeYXhehlqyweTSX]SSbflc]gqb[^ckqpljjpfV_ne_]f`_Zjdbe`eeelsaeehkrmbbRTalplke\\[keimq{yexUX^UScfmd_itd\\^ckrqnkeuiYaie`_hba]kecbceeenuceejlsoddUUblqmlf^]mfknr}{fzVY_VTegofamye\\_ckssomfff[bkfaaicc_mfedffffowdffgmpqefWVbmrnmg``oglogggg|WZ`XVdgrhcpgf]_dltsqnggg^dmgcckedbngfghgggqhfgghohtghZXchhohhcbhhmphhhh~X[`ZXdirkethh^_dlvusphhh_fnhcfmfeephgikhhhtzihhjpjzik\\[djjpjjfejjjjjjjjjY[a[Zelsphjjjb_dlwxtqjjjahjjjyphgjujjknjjjwjjjj", v100 * 72 + v106 + 1) - 33) * 4 + 280 - v110) * v103
    local v114 = (string.byte("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&&&%&&%&&&&&%&&&&&&&&%&&%&&&&&%&&%&&&&&%&&%&&%&&&&&&&&&&&&&&&&&&&&&&&%&&((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((************************************************************************,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,...............-................................................-........//..)+/0.//./-.000././/0//.//+,/0000//.0101,.//.//.//.//.000//0-..0.,1/SZTMKN1IVZVBHdQMNPQ@GScPPLOOAK-.ANNSUTIT_ha^OQXQEGKWXSTUROT\\@EXZ6XLNX0PT[[VOPOLLWe[ZXTQM\\VRFGXdTPKPOLN`dVOMYWTQT_idbQS\\SPHLZ[RSVROTdCFY\\[\\\\`[TUT\\\\XSQOKMXfjabWQM_XSPNbfWPLQQKNad]PNVXTQT^jecWV^VRHN]gSSWRNTfYV[]`W_adZYW]]c]RQJNYgkbbYRMaUTgnlgYQMQSJObd_QOTYURT^kfe`\\_XTIO_gTRXTNVgZW\\^YY`ae[XY^^g^TSINZhhccZSMdWUhonhZLMRUJObd`SPSZVST^lgga^`ZVIQ`hUSZUNVg[X\\^ZZabf[XZ__h_VUIO[qidd\\OMgXWhpoj\\MNRVJPbdbURT[WST]lhhc_b\\XISbjVS[VOWh]Z\\_\\\\bch\\X\\`aiaWVJP\\qjee\\PNiYYipqk\\MOSWKPbdcWTT\\WTT]liidac_ZKTdkXT]XQWh^[]`\\\\\\dj\\X\\abkcYXKP]ekfe]QN\\[[iqsn]MOTWLQbdeYUV]XUU]lkjebea\\LVfmYU^YSXh_\\]`]]]ek]]]bdldZYKQ^flgf^SP_]^jqrp^NPTXMQbdg[WX_XVW]llkgcgc^NXgoZW`[UXh`]^]^^^fm]^^cenf\\\\LR^gmhgaTQadfjrsraOQUZOQbej]XZcYXX]lmlheje`OZiq[Xa\\XYha^_]aaahn^aadfoh]]MR_jmihbUScefkoutbPRV\\PRbek_Z]j`Y[`lnmifhhbQ[kh\\Zc]ZYhb``^bbbip^bbehpj__NS_knjicWVfcglpwucQRW]QRbela\\enaZ^clpnkhikdS]mc][e_\\Zicab_ccckr_ccgiqka`PT`kokjeYXhehlqyweTSX]SSbflc]gqb[^ckqpljjpfV_ne_]f`_Zjdbe`eeelsaeehkrmbbRTalplke\\[keimq{yexUX^UScfmd_itd\\^ckrqnkeuiYaie`_hba]kecbceeenuceejlsoddUUblqmlf^]mfknr}{fzVY_VTegofamye\\_ckssomfff[bkfaaicc_mfedffffowdffgmpqefWVbmrnmg``oglogggg|WZ`XVdgrhcpgf]_dltsqnggg^dmgcckedbngfghgggqhfgghohtghZXchhohhcbhhmphhhh~X[`ZXdirkethh^_dlvusphhh_fnhcfmfeephgikhhhtzihhjpjzik\\[djjpjjfejjjjjjjjjY[a[Zelsphjjjb_dlwxtqjjjahjjjyphgjujjknjjjwjjjj", v105 * 72 + v107 + 1) - 33) * 4 + 280

    return v112 + (v114 + ((string.byte("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&&&%&&%&&&&&%&&&&&&&&%&&%&&&&&%&&%&&&&&%&&%&&%&&&&&&&&&&&&&&&&&&&&&&&%&&((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((************************************************************************,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,...............-................................................-........//..)+/0.//./-.000././/0//.//+,/0000//.0101,.//.//.//.//.000//0-..0.,1/SZTMKN1IVZVBHdQMNPQ@GScPPLOOAK-.ANNSUTIT_ha^OQXQEGKWXSTUROT\\@EXZ6XLNX0PT[[VOPOLLWe[ZXTQM\\VRFGXdTPKPOLN`dVOMYWTQT_idbQS\\SPHLZ[RSVROTdCFY\\[\\\\`[TUT\\\\XSQOKMXfjabWQM_XSPNbfWPLQQKNad]PNVXTQT^jecWV^VRHN]gSSWRNTfYV[]`W_adZYW]]c]RQJNYgkbbYRMaUTgnlgYQMQSJObd_QOTYURT^kfe`\\_XTIO_gTRXTNVgZW\\^YY`ae[XY^^g^TSINZhhccZSMdWUhonhZLMRUJObd`SPSZVST^lgga^`ZVIQ`hUSZUNVg[X\\^ZZabf[XZ__h_VUIO[qidd\\OMgXWhpoj\\MNRVJPbdbURT[WST]lhhc_b\\XISbjVS[VOWh]Z\\_\\\\bch\\X\\`aiaWVJP\\qjee\\PNiYYipqk\\MOSWKPbdcWTT\\WTT]liidac_ZKTdkXT]XQWh^[]`\\\\\\dj\\X\\abkcYXKP]ekfe]QN\\[[iqsn]MOTWLQbdeYUV]XUU]lkjebea\\LVfmYU^YSXh_\\]`]]]ek]]]bdldZYKQ^flgf^SP_]^jqrp^NPTXMQbdg[WX_XVW]llkgcgc^NXgoZW`[UXh`]^]^^^fm]^^cenf\\\\LR^gmhgaTQadfjrsraOQUZOQbej]XZcYXX]lmlheje`OZiq[Xa\\XYha^_]aaahn^aadfoh]]MR_jmihbUScefkoutbPRV\\PRbek_Z]j`Y[`lnmifhhbQ[kh\\Zc]ZYhb``^bbbip^bbehpj__NS_knjicWVfcglpwucQRW]QRbela\\enaZ^clpnkhikdS]mc][e_\\Zicab_ccckr_ccgiqka`PT`kokjeYXhehlqyweTSX]SSbflc]gqb[^ckqpljjpfV_ne_]f`_Zjdbe`eeelsaeehkrmbbRTalplke\\[keimq{yexUX^UScfmd_itd\\^ckrqnkeuiYaie`_hba]kecbceeenuceejlsoddUUblqmlf^]mfknr}{fzVY_VTegofamye\\_ckssomfff[bkfaaicc_mfedffffowdffgmpqefWVbmrnmg``oglogggg|WZ`XVdgrhcpgf]_dltsqnggg^dmgcckedbngfghgggqhfgghohtghZXchhohhcbhhmphhhh~X[`ZXdirkethh^_dlvusphhh_fnhcfmfeephgikhhhtzihhjpjzik\\[djjpjjfejjjjjjjjjY[a[Zelsphjjjb_dlwxtqjjjahjjjyphgjujjknjjjwjjjj", v105 * 72 + v106 + 1) - 33) * 4 + 280 - v114) * v103 - v112) * v102
end

local function radialOf(p27) -- line: 223
    return (Vector3.new(math.cos(p27), 0, (math.sin(p27))))
end

t1[1] = nil

local function wallAvg(p28, p29) -- line: 227
    -- upvalues: ARENA (copy), caveR (copy)
    local v118 = -ARENA.SMOOTH
    local SMOOTH = ARENA.SMOOTH
    local n3 = 0
    local n4 = 0

    for i = v118, SMOOTH, 5 do
        n3 += caveR(p28, p29 + math.rad(i))
        n4 += 1
    end

    return n3 / n4
end

local function buildProfiles() -- line: 235
    -- upvalues: ARENA (copy), t1 (copy), wallAvg (copy)
    t1[1] = {}

    for i = 0, 71 do
        local v119 = math.rad(i * 5)
        local v120 = wallAvg(-4020, v119)
        local t4 = {
            { 296, -4285 },
            { 296, -4160 },
            { 316, -4120 },
            { 332, -4082 },
            {
                345,
                ARENA.GROUND - 2
            },
            {
                v120 - 35,
                ARENA.GROUND
            },
            { v120, -4020 },
            {
                wallAvg(-3950, v119),
                -3950
            },
            {
                wallAvg(-3850, v119),
                -3850
            },
            {
                wallAvg(-3760, v119),
                -3760
            }
        }
        local t5 = {}

        for j = 1, #t4 - 1 do
            local v121 = t4[j]
            local v122 = t4[j + 1]
            local v126 = math.max(1, (math.floor(math.sqrt((v122[1] - v121[1]) ^ 2 + (v122[2] - v121[2]) ^ 2) / ARENA.STEP)))

            for k = 0, v126 - 1 do
                t5[#t5 + 1] = {
                    v121[1] + (v122[1] - v121[1]) * k / v126,
                    v121[2] + (v122[2] - v121[2]) * k / v126
                }
            end
        end

        t5[#t5 + 1] = {
            t4[#t4][1],
            t4[#t4][2]
        }

        local v128 = math.floor(ARENA.ROUND / ARENA.STEP / 2)
        local t6 = {}
        local t7 = {}

        for n = 1, #t5 do
            local v130 = math.max(1, n - v128)
            local v133 = math.min(#t5, n + v128)
            local n5 = 0
            local n6 = 0
            local n7 = 0

            for n2 = v130, v133 do
                n5 += t5[n2][1]
                n6 += t5[n2][2]
                n7 += 1
            end

            local v134 = n5 / n7
            local v135 = n6 / n7

            t6[n] = v134
            t7[n] = v135
        end

        local t8 = {
            0
        }

        for n3 = 2, #t6 do
            t8[n3] = t8[n3 - 1] + math.sqrt((t6[n3] - t6[n3 - 1]) ^ 2 + (t7[n3] - t7[n3 - 1]) ^ 2)
        end

        t1[1][i] = {
            r = t6,
            y = t7,
            v = t8
        }
    end
end

local function bucketAt(p30, p31) -- line: 267
    local v = p30.v
    local v140 = math.clamp(p31, 0, v[#v])
    local v141 = 1
    local v142 = #v

    while v142 - v141 > 1 do
        local v143 = (v141 + v142) // 2

        if v[v143] <= v140 then
            v141 = v143
        else
            v142 = v143
        end
    end

    local v146 = (v140 - v[v141]) / math.max(v[v142] - v[v141], 1E-06)
    local v147 = p30.r[v142] - p30.r[v141]
    local v148 = p30.y[v142] - p30.y[v141]
    local v151 = math.max(math.sqrt(v147 * v147 + v148 * v148), 1E-06)
    local v152 = p30.r[v141]
    local v153 = v152 + (p30.r[v142] - v152) * v146
    local v154 = p30.y[v141]

    return v153, v154 + (p30.y[v142] - v154) * v146, v147 / v151, v148 / v151
end

local function profileAt(p32, p33) -- line: 281
    -- upvalues: t1 (copy), buildProfiles (copy), bucketAt (copy)
    if not t1[1] then
        buildProfiles()
    end

    local v155 = math.deg(p32) % 360 / 5
    local v156 = math.floor(v155)
    local v157 = v155 - v156
    local v158, v159, v160, v161 = bucketAt(t1[1][v156 % 72], p33)
    local v162, v163, v164, v165 = bucketAt(t1[1][(v156 + 1) % 72], p33)
    local v166 = v160 + (v164 - v160) * v157
    local v167 = v161 + (v165 - v161) * v157
    local v170 = math.max(math.sqrt(v166 * v166 + v167 * v167), 1E-06)
    local v171 = v166 / v170
    local v172 = v167 / v170

    return v158 + (v162 - v158) * v157, v159 + (v163 - v159) * v157, v171, v172, -v172, v171
end

local function vAtY(p34, p35) -- line: 294
    -- upvalues: t1 (copy), buildProfiles (copy)
    if not t1[1] then
        buildProfiles()
    end

    local v175 = t1[1][math.floor(math.deg(p34) % 360 / 5 + 0.5) % 72]

    for i = 2, #v175.y do
        if p35 <= v175.y[i] then
            local v176 = v175.v[i - 1]
            local v177 = v175.v[i]
            local v180 = (p35 - v175.y[i - 1]) / math.max(v175.y[i] - v175.y[i - 1], 1E-06)

            return v176 + (v177 - v176) * v180
        end
    end

    return v175.v[#v175.v]
end

local function vLow(p36) -- line: 303
    -- upvalues: TitanPath (copy), ARENA (copy), vAtY (copy)
    local n8 = 1e999

    for _, v181 in ipairs(TitanPath.CAVE.PILLARS.ANGLES) do
        n8 = math.min(n8, (math.abs((math.deg(p36) - v181 + 180) % 360 - 180)))
    end

    local PILLAR = ARENA.PILLAR
    local v185 = math.clamp((n8 - PILLAR.NEAR) / (PILLAR.FAR - PILLAR.NEAR), 0, 1)
    local v186 = 1 - v185 * v185 * (3 - 2 * v185)
    local v187 = vAtY(p36, ARENA.LO_Y)

    if v186 <= 0 then
        return v187
    end

    return v187 + (vAtY(p36, ARENA.GROUND - 1) + PILLAR.GROUND_IN - v187) * v186
end

local function vHigh(p37) -- line: 312
    -- upvalues: ARENA (copy), vAtY (copy)
    return (vAtY(p37, ARENA.HI_Y))
end

local function surfFrame(p38, p39, p40, p41, p42, p43) -- line: 315
    -- upvalues: t2 (copy), ARENA (copy), v96 (copy), profileAt (copy)
    local v188, v189, v190, v191, v192, v193 = profileAt(p38, p39)
    local v196 = Vector3.new(math.cos(p38), 0, (math.sin(p38)))
    local v197 = v196 * v192 + Vector3.new(0, 1, 0) * v193
    local v198 = v196 * v190 + Vector3.new(0, 1, 0) * v191
    local v205 = CFrame.fromMatrix(Vector3.new(0, 0, 0), v198:Cross(v197), v197) * CFrame.Angles(-math.rad(p41 or 0), math.rad(p43 or 0), 0) * CFrame.Angles(0, 0, (math.rad(p42 or 0)))

    return CFrame.new(v96 + v196 * v188 + Vector3.new(0, 1, 0) * v189 + v197 * (ARENA.STAND + (p40 or 0))) * v205 * CFrame.new(-t2.CENTRE), v197
end

local function nearestRock(p44) -- line: 326
    -- upvalues: ARENA (copy), v96 (copy), caveR (copy)
    local v208 = math.atan2(p44.Z - v96.Z, p44.X - v96.X)
    local v211 = Vector3.new(math.cos(v208), 0, (math.sin(v208)))
    local Y = p44.Y
    local v213 = math.clamp(if ARENA.BAND[1] < Y and Y < ARENA.BAND[2] then Y - ARENA.BAND[1] < ARENA.BAND[2] - Y and ARENA.BAND[1] or ARENA.BAND[2] else Y, -4285, -3740)
    local v214 = v96 + v211 * caveR(v213, v208) + Vector3.new(0, 1, 0) * v213
    local v216 = v96 + v211 * math.clamp((Vector3.new(p44.X, 0, p44.Z) - v96).Magnitude, 332, (caveR(ARENA.BAND[2], v208))) + Vector3.new(0, 1, 0) * ARENA.GROUND

    if (v216 - p44).Magnitude < (v214 - p44).Magnitude then
        return v216, (Vector3.new(0, 1, 0))
    end

    return v214, -v211
end

local function leapFrame(p45, p46) -- line: 341
    -- upvalues: t2 (copy), ARENA (copy)
    local v218 = math.clamp((p46 - p45.t0) / (p45.t1 - p45.t0), 0, 1)
    local v219 = p45.A:PointToWorldSpace(t2.CENTRE)
    local v220 = p45.B:PointToWorldSpace(t2.CENTRE)
    local v221 = v219:Lerp(v220, v218) + Vector3.new(0, 1, 0) * (p45.arc * 4 * v218 * (1 - v218))
    local v222 = v220 - v219 + Vector3.new(0, 1, 0) * (p45.arc * 4 * (1 - v218 * 2))
    local v223 = Vector3.new(v222.X, 0, v222.Z)
    local v224 = v223.Magnitude > 0.001
    local Unit = if v224 then v223.Unit else nil

    if not v224 or not Unit then
        Unit = Vector3.new(p45.A.LookVector.X, 0, p45.A.LookVector.Z).Unit
    end

    local v226 = CFrame.fromMatrix(Vector3.new(0, 0, 0), Unit:Cross((Vector3.new(0, 1, 0))), (Vector3.new(0, 1, 0))) * CFrame.Angles(math.atan2(v222.Y, Vector3.new(v222.X, 0, v222.Z).Magnitude) * 0.5, 0, 0)
    local v227 = v218 < 0.45
    local v228

    if v227 then
        local Rotation = p45.A.Rotation
        local v230 = math.clamp(v218 / 0.35, 0, 1)

        v228 = Rotation:Lerp(v226, v230 * v230 * (3 - 2 * v230))
    end

    if not v227 or not v228 then
        local Rotation = p45.B.Rotation
        local v232 = math.clamp((v218 - 0.55) / 0.45, 0, 1)

        v228 = v226:Lerp(Rotation, v232 * v232 * (3 - 2 * v232))
    end

    if p45.shake then
        v228 *= CFrame.Angles(0, 0, math.rad(ARENA.SHAKE.DEG) * math.sin(6.283185307179586 * ARENA.SHAKE.HZ * (p46 - p45.t0)) * math.sin(3.141592653589793 * v218))
    end

    return CFrame.new(v221) * v228 * CFrame.new(-t2.CENTRE), v228.LookVector
end

local function runAt(p47, p48) -- line: 359
    -- upvalues: ARENA (copy)
    local dur, V = p47.dur, p47.V
    local RAMP, STOP = ARENA.RAMP, ARENA.STOP
    local v237 = math.clamp(p48, 0, dur)

    if v237 < RAMP then
        local v238 = v237 / RAMP

        return V * RAMP * (v238 ^ 3 - v238 ^ 4 / 2), V * v238 * v238 * (3 - 2 * v238)
    end

    local v239 = V * (dur - RAMP / 2 - STOP / 2)

    if dur - STOP < v237 then
        local v240 = (dur - v237) / STOP

        return v239 - V * STOP * (v240 ^ 3 - v240 ^ 4 / 2), V * v240 * v240 * (3 - 2 * v240)
    end

    return V * RAMP / 2 + V * (v237 - RAMP), V
end

local function segAt(p49, p50) -- line: 373
    local v241 = 1
    local v242 = #p49.segs

    while v241 < v242 do
        local v243 = (v241 + v242 + 1) // 2

        if p49.segs[v243].t0 <= p50 then
            v241 = v243
        else
            v242 = v243 - 1
        end
    end

    return v241
end

local function runPlace(p51, p52) -- line: 382
    return p51.th0 + p51.a * p52 / p51.rr, p51.v0 + p51.b * p52
end

local function placeAt(p53, p54) -- line: 386
    -- upvalues: runAt (copy), segAt (copy)
    local v244 = p53.segs[segAt(p53, p54)]

    if v244.kind ~= "run" then
        return v244.th, v244.v, 0, v244, v244.D
    end

    local v245, v246 = runAt(v244, p54 - v244.t0)

    return v244.th0 + v244.a * v245 / v244.rr, v244.v0 + v244.b * v245, v246, v244, v244.D0 + v245
end

local function peekK(p55, p56) -- line: 396
    -- upvalues: ARENA (copy)
    if not p55.peek then
        return 0
    end

    local PEEK = ARENA.PEEK
    local v247 = p56 - p55.peek

    if v247 < 0 then
        return 0
    end

    if v247 < PEEK.RISE then
        local v249 = math.clamp(v247 / PEEK.RISE, 0, 1)

        return v249 * v249 * (3 - 2 * v249)
    end

    if v247 < PEEK.RISE + PEEK.HOLD then
        return 1
    end

    local v251 = math.clamp((v247 - PEEK.RISE - PEEK.HOLD) / PEEK.RISE, 0, 1)

    return 1 - v251 * v251 * (3 - 2 * v251)
end

local function bodyAt(p57, p58) -- line: 406
    -- upvalues: ARENA (copy), surfFrame (copy), leapFrame (copy), runAt (copy), segAt (copy), peekK (copy)
    local v252 = p57.segs[segAt(p57, p58)]

    if v252.kind == "jump" then
        return leapFrame(v252, p58)
    end

    local v253 = p57.segs[segAt(p57, p58)]
    local v254, v255, v256, v257

    if v253.kind == "run" then
        local v258

        v258, v254 = runAt(v253, p58 - v253.t0)
        v255 = v253.th0 + v253.a * v258 / v253.rr
        v256 = v253.v0 + v253.b * v258
        v257 = v253.D0 + v258
    else
        v255 = v253.th
        v256 = v253.v
        v254 = 0
        v257 = v253.D
    end

    local v260 = math.min(math.abs(v254) / ARENA.SPEED[2], 1)
    local v261 = v252.kind == "freeze" and peekK(v252, p58) or 0
    local v262, v263, v264

    if v252.kind ~= "freeze" or v252.calm then
        v264 = 0
    else
        v262 = ARENA.TWITCH.DEG * math.noise(p58 * ARENA.TWITCH.HZ, v252.seed % 997 + 0.5)
        v263 = if math.noise(p58 * 1.3, v252.seed % 541 + 0.5) > 0.15 then 1 else 0
        v264 = v262 * v263
    end

    local v269 = surfFrame(v255, v256, ARENA.BOB * math.cos(12.566370614359172 * v257 / ARENA.CYCLE) * v260 + ARENA.PEEK.UP * v261, ARENA.PEEK.PITCH * v261 + v264 * 0.5, -(if (v252.a or 1) >= 0 then 1 else -1) * ARENA.LEAN * v260 + v264, v264 * 0.7)

    return v269, v269.LookVector
end

local function odoPlace(p59, p60) -- line: 424
    -- upvalues: ARENA (copy), runPlace (copy)
    local runs = p59.runs
    local v270 = 1
    local v271 = #runs

    while v270 < v271 do
        local v272 = (v270 + v271 + 1) // 2

        if runs[v272].D0 <= p60 then
            v270 = v272
        else
            v271 = v272 - 1
        end
    end

    local v273 = runs[v270]

    if v273.D0 + v273.len < p60 then
        local v274 = runs[v270 + 1]

        if v274 and v274.jumped and v274.D0 - ARENA.CYCLE <= p60 then
            return runPlace(v274, 0)
        end

        return runPlace(v273, v273.len)
    end

    return runPlace(v273, (math.max(0, p60 - v273.D0)))
end

local t9 = {}

local function arenaOf(p61, _, p63) -- line: 441
    -- upvalues: TitanPath (copy), TitanConfig (copy), t2 (copy), ARENA (copy), v96 (copy), profileAt (copy), vAtY (copy), vLow (copy), surfFrame (copy), runPlace (copy), t9 (copy)
    if t9[p61] then
        return t9[p61]
    end

    local EMERGE, JUMP = ARENA.EMERGE, ARENA.JUMP
    local v276 = Random.new(TitanConfig.Seed(p61) * 15485863 + 77)

    local function roll(p64) -- line: 445
        -- upvalues: v276 (copy)
        return p64[1] + (p64[2] - p64[1]) * v276:NextNumber()
    end

    local t10 = {
        segs = {},
        runs = {},
        t0 = TitanPath.CaveAt(p61)
    }
    local n9 = 0

    local function addRun(p65, p66, p67, p68, p69, p70, p71, p72) -- line: 448
        -- upvalues: t10 (copy), n9 (ref), ARENA (copy), profileAt (copy)
        local v277, _, _, _, v278 = profileAt(p67, p68 + p70 * p71 / 2)
        local t11 = {
            kind = "run",
            t0 = p65,
            t1 = p65 + p66,
            dur = p66,
            th0 = p67,
            v0 = p68,
            a = p69,
            b = p70,
            len = p71,
            rr = v277 + v278 * ARENA.STAND,
            D0 = n9,
            V = p71 / math.max(p66 - ARENA.RAMP / 2 - ARENA.STOP / 2, 0.05)
        }

        for v280, v281 in pairs(p72 or {}) do
            t11[v280] = v281
        end

        t10.segs[#t10.segs + 1] = t11
        t10.runs[#t10.runs + 1] = t11
        n9 += p71

        return t11
    end

    local function blocked(p73, p74, p75) -- line: 459
        -- upvalues: JUMP (copy), TitanPath (copy), v96 (copy)
        for i = 1, 23 do
            local v282 = i / 24
            local v283 = p73:Lerp(p74, v282) + Vector3.new(0, 1, 0) * (p75 * 4 * v282 * (1 - v282))

            for _, v284 in ipairs(TitanPath.CAVE.PILLARS.ANGLES) do
                local v285 = math.rad(v284)
                local v288 = v96 + Vector3.new(math.cos(v285), 0, (math.sin(v285))) * TitanPath.CAVE.PILLARS.RADIUS

                if v283.Y < JUMP.TOP and (Vector3.new(v283.X, 0, v283.Z) - v288).Magnitude < JUMP.CLEAR then
                    return true
                end
            end
        end

        return false
    end

    local v289 = TitanPath.At(p61, TitanPath.APEX_S, p63)

    v289 = -(Vector3.new(0, 1, 0)):Cross(Vector3.new(v289.X - v96.X, 0, v289.Z - v96.Z).Unit)

    local v292, X = v289.Z, v289.X
    local v295 = math.floor((math.deg((math.atan2(v292, X))) - 30) / 60 + 0.5) * 60 + 30
    local v290 = math.rad(v295)
    local v296 = v290
    local v297 = TitanPath.EruptAt(p61)
    local v291 = TitanPath.ThrowAt(p61)
    local v298 = vAtY(v290, EMERGE.FLOOR)
    local v294 = vAtY(v290, EMERGE.TOP)

    addRun(t10.t0, v297 - 0.05 - t10.t0, v290, v298, 0, 1, v294 - v298)
    v298 = addRun(v297 - 0.05, EMERGE.HAUL, v290, v294, 0, 1, EMERGE.UP, {
        t1 = v291 - EMERGE.FLING,
        release = v291 - EMERGE.FLING,
        strikes = {
            {
                side = "L",
                at = v297
            },
            {
                side = "R",
                at = v297 + 0.07
            },
            {
                side = "L",
                at = v297 + EMERGE.REGRAB
            },
            {
                side = "R",
                at = v297 + EMERGE.REGRAB + 0.1
            }
        }
    })
    v294 = vAtY(v290, EMERGE.WALL)

    local segs = t10.segs
    local v299 = #t10.segs + 1
    local v300 = {
        kind = "jump",
        shake = true,
        t0 = v298.t1,
        t1 = v298.t1 + EMERGE.FLY
    }
    local v301 = v298.len

    v300.A = surfFrame(runPlace(v298, v301))
    v300.B = surfFrame(v290, v294)
    v300.arc = EMERGE.ARC
    v300.D = n9
    segs[v299] = v300
    segs = 2 * ARENA.CYCLE
    n9 += segs
    v291 = v298.t1 + EMERGE.FLY
    t10.segs[#t10.segs + 1] = {
        kind = "freeze",
        calm = true,
        t0 = v291,
        t1 = v291 + JUMP.LAND,
        th = v290,
        v = v294,
        D = n9
    }
    v291 += JUMP.LAND

    local v302 = v294

    v299 = if v276:NextNumber() < 0.5 then 1 else -1
    v300 = true

    local v293 = true

    while v291 < t10.t0 + ARENA.SPAN do
        local v303, v304, Magnitude, v305, v306, v307, CEIL, Y, Y2, v308, v309, v310

        if v293 then
            v308 = false
        elseif v276:NextNumber() < JUMP.CHANCE then
            v292 = surfFrame(v296, v302)
            v308 = false

            for _ = 1, 6 do
                v310 = JUMP.TURN
                v303 = v310[1] + (v310[2] - v310[1]) * v276:NextNumber()
                v304 = math.rad(v303)
                v303 = if v276:NextNumber() < 0.5 then -1 else 1
                Magnitude = v304 * v303
                v295 = v296 + Magnitude
                v303 = vLow(v295)
                v304 = vAtY(v295, ARENA.HI_Y)

                local v311 = v303 + v276:NextNumber() * (v304 - v303)

                v304 = surfFrame(v295, v311)
                v309 = v292:PointToWorldSpace(t2.CENTRE)
                v310 = v304:PointToWorldSpace(t2.CENTRE)
                Magnitude = (v310 - v309).Magnitude
                v305 = JUMP.ARC[1] + Magnitude * JUMP.ARC_K
                CEIL = JUMP.ARC[1]
                v306 = JUMP.ARC[2]
                v307 = math.clamp(v305, CEIL, v306)
                CEIL = JUMP.CEIL
                Y = v309.Y
                Y2 = v310.Y
                v305 = CEIL - math.max(Y, Y2)

                local v312 = math.min(v307, v305)

                if v312 > 20 and not blocked(v309, v310, v312) then
                    v307 = JUMP.BASE + Magnitude / JUMP.SPEED
                    v305 = JUMP.MIN
                    CEIL = JUMP.MAX
                    v309 = math.clamp(v307, v305, CEIL)
                    t10.segs[#t10.segs + 1] = {
                        kind = "jump",
                        t0 = v291,
                        t1 = v291 + v309,
                        A = v292,
                        B = v304,
                        arc = v312,
                        D = n9
                    }
                    v312 = 2 * ARENA.CYCLE
                    n9 += v312
                    v291 += v309
                    t10.segs[#t10.segs + 1] = {
                        kind = "freeze",
                        calm = true,
                        t0 = v291,
                        t1 = v291 + JUMP.LAND,
                        th = v295,
                        v = v311,
                        D = n9
                    }
                    v291 += JUMP.LAND
                    v296 = v295
                    v302 = v311
                    v290 = v295
                    v308 = true
                    v294 = v311
                    v300 = true
                    v293 = true
                    break
                end
            end
        else
            v308 = false
        end

        local v313, v314, v315, v316, v317

        if v308 then
            v316 = v293
            v313 = v290
            v315 = v291
            v314 = v294
            v317 = v300
        else
            local v318 = if not (v276:NextNumber() < ARENA.TURN) then v299 else -v299

            v301 = ARENA.SPEED
            v292 = v301[1] + (v301[2] - v301[1]) * v276:NextNumber()
            v301 = ARENA.RUN
            v301 = v292 * (v301[1] + (v301[2] - v301[1]) * v276:NextNumber() - ARENA.RAMP / 2 - ARENA.STOP / 2)
            Magnitude = 0

            for _, v319 in ipairs(ARENA.GOALS) do
                Magnitude += v319[2]
            end

            v303 = v276:NextNumber() * Magnitude
            v304 = nil

            for _, v320 in ipairs(ARENA.GOALS) do
                v303 -= v320[2]

                if v303 <= 0 then
                    v304 = v320
                    break
                end

                v304 = nil
            end

            v310 = v304 or ARENA.GOALS[#ARENA.GOALS]

            local v321
            local v322 = v318

            if v310[1] == "inner" then
                v303 = math.deg(v296)
                v307 = (v303 - 30) / 60 + 0.5

                local v324 = (math.floor(v307) * 60 + 30 - v303 + 180) % 360 - 180

                if math.abs(v324) > 3 then
                    v321 = if v324 > 0 then 1 else -1
                    v322 = v321
                end
            end

            v310 = vAtY(v296, v310[3] + v276:NextNumber() * (v310[4] - v310[3]))
            v305 = ARENA.DIAG
            v307 = math.rad(v305)
            v309 = math.sin(v307)
            v307 = (v310 - v302) / math.max(v301, 1)
            v305 = -v309
            v309 = math.clamp(v307, v305, v309)
            v305 = 1 - v309 * v309
            v310 = v322 * math.sqrt(v305)

            local v325 = vLow(v296)
            local v326 = v296
            local v327 = vAtY(v326, ARENA.HI_Y)

            local function roomOf(p76) -- line: 542
                -- upvalues: v302 (ref), v325 (copy), v327 (copy)
                local v328, v329

                if p76 > 0 then
                    local v330 = (v327 - v302) / p76

                    if v330 then
                        v328 = v330
                        v329 = true
                    elseif p76 < 0 then
                        local v331 = v302
                        local v332 = (v331 - v325) / -p76

                        if v332 then
                            v328 = v332
                            v329 = true
                        else
                            v329 = false
                        end
                    else
                        v329 = false
                    end
                elseif p76 < 0 then
                    local v333 = v302
                    local v334 = (v333 - v325) / -p76

                    if v334 then
                        v328 = v334
                        v329 = true
                    else
                        v329 = false
                    end
                else
                    v329 = false
                end

                if not v329 then
                    v328 = 1e999
                end

                return v328
            end

            local v335, v336

            if v309 > 0 then
                CEIL = (v327 - v302) / v309

                if CEIL then
                    v335 = CEIL
                    v336 = true
                elseif v309 < 0 then
                    local v337 = v302

                    CEIL = (v337 - v325) / -v309

                    if CEIL then
                        v335 = CEIL
                        v336 = true
                    else
                        v336 = false
                    end
                else
                    v336 = false
                end
            elseif v309 < 0 then
                local v338 = v302

                CEIL = (v338 - v325) / -v309

                if CEIL then
                    v335 = CEIL
                    v336 = true
                else
                    v336 = false
                end
            else
                v336 = false
            end

            if not v336 then
                v335 = 1e999
            end

            if v335 < 80 then
                v309 = -v309
            end

            local v339

            CEIL, v306, Y, Y2, v339 = profileAt(v296, v302)

            local v340 = CEIL + v339 * ARENA.STAND

            local function under(p77, p78, p79) -- line: 547
                -- upvalues: v296 (ref), v302 (ref), v340 (copy), vLow (copy)
                for i = 1, 16 do
                    local v341 = p79 * i / 16

                    if v302 + p77 * v341 < vLow(v296 + p78 * v341 / v340) - 1 then
                        return p79 * (i - 1) / 16
                    end
                end

                return nil
            end

            local v342, v343, v344

            for _ = 1, 4 do
                local v345, v346

                if v309 > 0 then
                    v342 = (v327 - v302) / v309

                    if v342 then
                        v345 = v342
                        v346 = true
                    elseif v309 < 0 then
                        local v347 = v302

                        v342 = (v347 - v325) / -v309

                        if v342 then
                            v345 = v342
                            v346 = true
                        else
                            v346 = false
                        end
                    else
                        v346 = false
                    end
                elseif v309 < 0 then
                    local v348 = v302

                    v342 = (v348 - v325) / -v309

                    if v342 then
                        v345 = v342
                        v346 = true
                    else
                        v346 = false
                    end
                else
                    v346 = false
                end

                if not v346 then
                    v345 = 1e999
                end

                v343 = under(v309, v310, (math.min(v301, v345)))

                if not v343 or v343 >= 60 then
                    break
                end

                v342 = v309 + 0.35
                v309 = math.min(1, v342)
                v344 = math.max(0, 1 - v309 * v309)
                v310 = v322 * math.sqrt(v344)
            end

            local v350, v351, v352

            if v309 > 0 then
                v350 = (v327 - v302) / v309

                if v350 then
                    v351 = v350
                    v352 = true
                elseif v309 < 0 then
                    local v353 = v302

                    v350 = (v353 - v325) / -v309

                    if v350 then
                        v351 = v350
                        v352 = true
                    else
                        v352 = false
                    end
                else
                    v352 = false
                end
            elseif v309 < 0 then
                local v354 = v302

                v350 = (v354 - v325) / -v309

                if v350 then
                    v351 = v350
                    v352 = true
                else
                    v352 = false
                end
            else
                v352 = false
            end

            if not v352 then
                v351 = 1e999
            end

            v313 = math.min(v301, v351)
            v301 = under(v309, v310, v313) or v313

            local v355, v356, v357

            if v301 < 20 then
                v350 = math.min((v327 - v302) / 1 or 1e999, 60)
                v355 = math.max(20, v350)
                v356 = 0
                v357 = 1
            else
                v357 = v309
                v355 = v301
                v356 = v310
            end

            v339 = addRun(v291, v355 / v292 + ARENA.RAMP / 2 + ARENA.STOP / 2, v296, v302, v356, v357, v355, {
                jumped = v300
            })
            v291 = v339.t1
            v313 = v339.th0 + v339.a * v355 / v339.rr
            v314 = v339.v0 + v339.b * v355
            v296 = v313
            v302 = v314
            v339 = {
                kind = "freeze",
                t0 = v291,
                th = v296,
                v = v302,
                D = n9,
                seed = v276:NextInteger(1, 1E+06),
                a = v356
            }

            local FREEZE = ARENA.FREEZE

            CEIL = FREEZE[1] + (FREEZE[2] - FREEZE[1]) * v276:NextNumber()

            if v276:NextNumber() < ARENA.PEEK.CHANCE then
                v339.peek = v291 + 0.1
                v339.roar = v276:NextNumber() < ARENA.PEEK.ROAR
                v339.strikes = {}
                FREEZE = 2 * ARENA.PEEK.STRIKES - 1

                for i = 0, FREEZE do
                    v343 = v339.strikes
                    v344 = #v339.strikes + 1
                    v342 = {
                        at = v339.peek + ARENA.PEEK.RISE + i * ARENA.PEEK.GAP
                    }
                    v342.side = i % 2 == 0 and "L" or "R"
                    v343[v344] = v342
                end

                v339.release = v339.peek + ARENA.PEEK.RISE + ARENA.PEEK.HOLD
                v350 = 0.2 + 2 * ARENA.PEEK.RISE + ARENA.PEEK.HOLD
                CEIL = math.max(CEIL, v350)
            end

            v339.t1 = v291 + CEIL
            t10.segs[#t10.segs + 1] = v339
            v315 = v339.t1
            v299 = v322
            v317 = false
            v316 = false
        end

        v293 = v316
        v290 = v313
        v291 = v315
        v294 = v314
        v300 = v317
    end

    t9[p61] = t10
    t9[p61 - 2 * TitanConfig.EVERY] = nil

    return t10
end

local function arenaFrame(p80, p81) -- line: 595
    -- upvalues: bodyAt (copy)
    return bodyAt(p80, p81)
end

function t2.Body(p82, p83, p84) -- line: 598
    -- upvalues: TitanPath (copy), climbFrame (copy), pathFrame (copy), arenaOf (copy), arenaFrame (copy)
    p84 = p84 or TitanPath.Direction(p82)

    local v360 = TitanPath.HeadS(p82, p83)
    local v361 = TitanPath.Climb(p82)
    local v362 = p83 - p82

    if v361 then
        if not TitanPath.cave and v362 < v361.D then
            return climbFrame(p82, v361, v362, v360, p84)
        end

        if TitanPath.cave then
            local v363 = arenaOf(p82, v361, p84)

            if v363.t0 <= p83 then
                return arenaFrame(v363, p83)
            end
        end
    end

    return pathFrame(p82, v360, p84)
end

local function solve(p85, p86, p87, p88, p89) -- line: 615
    local v364 = p86 - p85
    local v368 = math.clamp(v364.Magnitude, math.abs(p87 - p88) + 0.01, (p87 + p88) * 0.999)
    local Unit = v364.Magnitude > 1E-04 and v364.Unit or Vector3.new(0, 1, 0)
    local v369 = p89 - Unit * p89:Dot(Unit)
    local Unit2 = v369.Magnitude > 1E-04 and v369.Unit or Unit:Cross((Vector3.new(1, 0, 0))).Unit
    local v370 = (p87 * p87 + v368 * v368 - p88 * p88) / (2 * p87 * v368)
    local v373 = math.sqrt((math.max(0, 1 - v370 * v370)))

    return p85 + Unit * (p87 * v370) + Unit2 * (p87 * v373), p85 + Unit * v368
end

local function frameOf(p90, p91) -- line: 625
    return CFrame.fromMatrix(Vector3.new(0, 0, 0), p90, p91)
end

local function pose2(p92, p93, p94) -- line: 628
    local Unit = (p93 - p92.hip).Unit
    local Unit2 = (p94 - p93).Unit
    local v374 = Unit:Cross(Unit2)
    local Unit3 = v374.Magnitude > 1E-05 and v374.Unit or p92.Nr
    local v375 = CFrame.fromMatrix(Vector3.new(0, 0, 0), Unit, Unit3) * p92.Ar:Inverse()

    p92.a.Transform = p92.Ra:Inverse() * v375 * p92.Ra

    local v376 = v375:VectorToWorldSpace(p92.tr)
    local v379 = math.atan2(v376:Cross(Unit2):Dot(Unit3), (v376:Dot(Unit2)))

    p92.b.Transform = CFrame.fromAxisAngle(p92.Rb:VectorToObjectSpace(p92.Nr), v379)

    return v375, Unit3, v379
end

local function poseClaw(p95, p96, p97) -- line: 641
    -- upvalues: solve (copy), pose2 (copy)
    local v380, v381 = solve(p95.hip, p96 - p97 * p95.L3, p95.L1, p95.L2, p95.pole)
    local v382, v383, v384 = pose2(p95, v380, v381)
    local v385 = CFrame.fromAxisAngle(v383, v384) * v382
    local v386 = v385:VectorToWorldSpace(p95.sr)
    local v387 = v386:Cross(p97)

    if not (v387.Magnitude > 1E-05) then
        p95.c.Transform = CFrame.identity

        return
    end

    local v389 = math.atan2(v387.Magnitude, (v386:Dot(p97)))

    p95.c.Transform = CFrame.fromAxisAngle(p95.Rc:VectorToObjectSpace(v385:VectorToObjectSpace(v387.Unit)), v389)
end

function t2.Rig(p98, p99) -- line: 658
    -- upvalues: TitanPath (copy), t2 (copy), t3 (copy)
    p99 = p99 or 1

    local PrimaryPart = p98.PrimaryPart
    local _CFrame = PrimaryPart.CFrame
    local t12 = {}

    for _, descendant in ipairs(PrimaryPart:GetDescendants()) do
        if descendant:IsA("Bone") then
            t12[descendant.Name] = descendant
        end
    end

    local function lp(p100) -- line: 666
        -- upvalues: _CFrame (copy)
        return _CFrame:PointToObjectSpace(p100.WorldPosition)
    end

    local function lr(p101) -- line: 667
        -- upvalues: _CFrame (copy)
        return _CFrame:ToObjectSpace(p101.WorldCFrame).Rotation
    end

    local LEG, CLAW = t2.LIMB.LEG, t2.LIMB.CLAW
    local t13 = {}

    local function chain(p102, p103, p104, p105) -- line: 671
        -- upvalues: _CFrame (copy)
        p102.hip = p103
        p102.knee = p104

        local Magnitude = (p104 - p103).Magnitude
        local Magnitude2 = (p105 - p104).Magnitude

        p102.L1 = Magnitude
        p102.L2 = Magnitude2

        local Unit = (p104 - p103).Unit
        local Unit2 = (p105 - p104).Unit

        p102.tr = Unit2
        p102.Nr = Unit:Cross(Unit2).Unit

        local Nr = p102.Nr

        p102.Ar = CFrame.fromMatrix(Vector3.new(0, 0, 0), Unit, Nr)

        local Unit3 = (p105 - p103).Unit

        p102.pole = (p104 - p103 - Unit3 * (p104 - p103):Dot(Unit3)).Unit

        local Rotation = _CFrame:ToObjectSpace(p102.a.WorldCFrame).Rotation
        local Rotation2 = _CFrame:ToObjectSpace(p102.b.WorldCFrame).Rotation

        p102.Ra = Rotation
        p102.Rb = Rotation2
    end

    for _, v391 in ipairs({ "L", "R" }) do
        local v392 = if v391 == "L" then Vector3.new(1, 1, 1) else Vector3.new(-1, 1, 1)

        for i = 1, 5 do
            local t14 = {
                kind = "leg",
                side = v391,
                i = i,
                a = t12[("Leg%d%s_Femur"):format(i, v391)],
                b = t12[("Leg%d%s_Tibia"):format(i, v391)],
                tip = t3[i] * v392 * p99
            }

            chain(t14, _CFrame:PointToObjectSpace(t14.a.WorldPosition), _CFrame:PointToObjectSpace(t14.b.WorldPosition), t14.tip)
            t14.reach = (t14.tip - t14.hip).Unit
            t14.fly = t14.tip + t2.LIMB.FLY.LEG * p99

            local v393 = LEG.LIFT + (i - 1) * LEG.LIFT_STEP
            local v394 = v391 == "R"
            local SIDE_STEP = if v394 then LEG.SIDE_STEP else nil

            t14.lift = v393 + (if not v394 or not SIDE_STEP then 0 else SIDE_STEP)

            local v395 = TitanPath.STYLES.Karkinos.CLIMB.CATCH + (i - 1) * LEG.LAND_STEP
            local v396 = v391 == "R"
            local SIDE_STEP2 = if v396 then LEG.SIDE_STEP else nil

            t14.land = v395 + (if not v396 or not SIDE_STEP2 then 0 else SIDE_STEP2)
            t13[#t13 + 1] = t14
        end

        local t15 = {
            kind = "claw",
            i = 0,
            side = v391,
            a = t12["Claw" .. v391 .. "_Arm"],
            b = t12["Claw" .. v391 .. "_Forearm"],
            c = t12["Claw" .. v391 .. "_Scythe"],
            tip = Vector3.new(-4.2, -35.5, -82.4) * v392 * p99
        }
        local v397 = _CFrame:PointToObjectSpace(t15.c.WorldPosition)

        chain(t15, _CFrame:PointToObjectSpace(t15.a.WorldPosition), _CFrame:PointToObjectSpace(t15.b.WorldPosition), v397)
        t15.L3 = (t15.tip - v397).Magnitude
        t15.sr = (t15.tip - v397).Unit
        t15.Rc = _CFrame:ToObjectSpace(t15.c.WorldCFrame).Rotation
        t15.reach = (CLAW.AIM * Vector3.new(v391 == "L" and -1 or 1, 1, 1)).Unit

        local tip, sr = t15.tip, t15.sr

        t15.fly = tip
        t15.flySd = sr

        local v399 = CLAW.LIFT[v391]
        local v400 = CLAW.LAND[v391]

        t15.lift = v399
        t15.land = v400
        t13[#t13 + 1] = t15
    end

    local t16 = {}

    for v401, v402 in ipairs(t13) do
        v402.id = v401

        if v402.kind == "claw" then
            t16[v402.side] = v402
        end
    end

    return {
        limbs = t13,
        bones = t12,
        holds = {},
        claws = t16
    }
end

local function holdOf(p106, p107, p108, p109, p110, p111) -- line: 718
    -- upvalues: TitanPath (copy), TitanConfig (copy), t2 (copy), AXIS (copy), wallR (copy), toWall (copy), climbFrame (copy)
    if p106.holds.rise ~= p107 then
        p106.holds = {
            rise = p107
        }
    end

    local v403 = p110 * 32 + p109.id

    if p106.holds[v403] then
        return p106.holds[v403]
    end

    local C = p108.C
    local LEG, CLAW = t2.LIMB.LEG, t2.LIMB.CLAW
    local v404 = p109.kind == "claw"
    local v405 = (p110 + p109.land - C.FROM) * p108.T
    local v406, v407 = climbFrame(p107, p108, v405, TitanPath.ClimbS(p108, v405), p111)
    local v409 = math.rad((Random.new(TitanConfig.Seed(p107) * 104729 + p110 * 61 + p109.id * 7):NextNumber() * 2 - 1) * (if v404 then 5 else LEG.SPREAD))
    local v410 = v406:PointToWorldSpace(p109.hip)
    local v411 = (p109.L1 + p109.L2) * (v404 and CLAW.REACH or LEG.REACH)
    local v412 = CFrame.fromAxisAngle(v407, v409):VectorToWorldSpace(v406:VectorToWorldSpace(p109.reach))
    local v413 = if not v404 or not v410 then v410 + v407 * LEG.UP else v410
    local v414, Unit

    if v404 and p110 == C.BOUNDS - 1 then
        local v415 = toWall(v413, v412)

        if v415 then
            local v418 = math.atan2(v415.Z - AXIS.Z, v415.X - AXIS.X)
            local v421 = Vector3.new(math.cos(v418), 0, (math.sin(v418)))

            v414 = Vector3.new(AXIS.X, CLAW.RIM_Y, AXIS.Z) + v421 * (wallR(0, v418) + CLAW.RIM_IN)
            Unit = (Vector3.new(-0, -1, -0, -0) * CLAW.HOOK + v421 * (1 - CLAW.HOOK)).Unit

            if not ((v414 - Unit * p109.L3 - v410).Magnitude <= v411) then
                v414 = nil
                Unit = nil
            end
        end
    end

    if v404 and not v414 then
        local v422 = toWall(v413, Vector3.new(v412.X, 0, v412.Z).Unit)

        if v422 then
            local v425 = math.atan2(v422.Z - AXIS.Z, v422.X - AXIS.X)
            local v428 = Vector3.new(math.cos(v425), 0, (math.sin(v425)))
            local Unit2 = (v428 * (1 - CLAW.STRIKE) - Vector3.new(0, 1, 0) * CLAW.STRIKE).Unit

            for i = 0, 12 do
                local v429 = v410.Y + CLAW.HIGH - i * CLAW.STEP
                local v430 = Vector3.new(AXIS.X, v429, AXIS.Z) + v428 * wallR(v429, v425)

                if (v430 - Unit2 * p109.L3 - v410).Magnitude <= v411 then
                    v414 = v430
                    Unit = Unit2
                    break
                end
            end
        end
    end

    if not v414 then
        for _ = 1, 8 do
            local v431 = toWall(v413, v412)

            if v431 then
                local v435 = math.atan2(v431.Z - AXIS.Z, v431.X - AXIS.X)
                local v438 = Vector3.new(math.cos(v435), 0, (math.sin(v435)))
                local v439 = v431
                local v432

                if v404 then
                    v432 = (v438 * (1 - CLAW.STRIKE) - v407 * CLAW.STRIKE).Unit or nil
                    v439 = v431 - v432 * p109.L3 or v431
                end

                if (v439 - v410).Magnitude <= v411 then
                    v414 = v431
                    Unit = v432
                    break
                end
            end

            local v440 = Vector3.new(v412.X, 0, v412.Z)
            local v441 = v412 * 0.65

            v412 = v440.Magnitude > 0.001 and v440.Unit or v412
            v412 = (v441 + v412 * 0.35 - v407 * 0.12).Unit
        end
    end

    local v442, v443

    if v414 then
        v443 = Unit
        v442 = v414
    else
        local v444 = Vector3.new(v412.X, 0, v412.Z)

        v443 = if v404 then v444.Magnitude > 0.001 and v444.Unit or v412 or nil else nil
        v442 = v410 + v412 * v411 + (v443 and v443 * p109.L3 or Vector3.new(0, 0, 0))
    end

    local t17 = {
        pos = v442,
        sd = v443
    }

    p106.holds[v403] = t17

    return t17
end

local function swing(p112, p113, p114, p115, p116, p117) -- line: 791
    -- upvalues: t2 (copy), AXIS (copy)
    local CLAW = t2.LIMB.CLAW
    local v446 = p115 * p115 * (2 - p115)
    local v447 = p113.pos:Lerp(p114.pos, v446)
    local v449 = math.sin(3.141592653589793 * p115)
    local v450

    if p117 then
        v450 = p117
    else
        local v453 = Vector3.new(v447.X - AXIS.X, 0, v447.Z - AXIS.Z)

        v450 = v453.Magnitude > 0.001 and -v453.Unit or Vector3.new(-1, -0, -0, -0)
    end

    if p112.kind == "leg" then
        return v447 + v450 * (t2.LIMB.LEG.OFF * v449), nil
    end

    local v454 = v447 + (v450 * (CLAW.COCK.IN * v449) + p116 * (CLAW.COCK.UP * v449))
    local Unit = (p116 * 0.75 - v450 * 0.25).Unit
    local v455

    if p115 < 0.6 then
        local sd = p113.sd
        local v457 = math.clamp(p115 / 0.6, 0, 1)

        v455 = sd:Lerp(Unit, v457 * v457 * (3 - 2 * v457))
    else
        local v458 = (p115 - 0.6) / 0.4

        v455 = Unit:Lerp(p114.sd, v458 * v458)
    end

    return v454, v455.Magnitude > 1E-04 and v455.Unit or p114.sd
end

local function place(p118, p119, p120, p121) -- line: 814
    -- upvalues: solve (copy), pose2 (copy), poseClaw (copy)
    local v459 = p119:PointToObjectSpace(p120)

    if p118.kind == "leg" then
        local v460, v461 = solve(p118.hip, v459, p118.L1, p118.L2, p118.pole)

        pose2(p118, v460, v461)
    else
        poseClaw(p118, v459, p119:VectorToObjectSpace(p121))
    end
end

t2.Place = place

local function legPhase(p122) -- line: 830
    return (if p122.i % 2 == 1 == (p122.side == "L") then 0 else 0.5) + p122.i * 0.025
end

local function stepHold(p123, p124, p125, p126, p127) -- line: 833
    -- upvalues: t2 (copy), ARENA (copy), surfFrame (copy), nearestRock (copy), odoPlace (copy)
    if p123.holds.rise ~= p124 then
        p123.holds = {
            count = 0,
            rise = p124
        }
    end

    local v462 = 1E+05 + p127 * 16 + p126.id
    local v463 = p123.holds[v462]

    if v463 then
        return v463
    end

    local v465 = surfFrame(odoPlace(p125, (p127 + ((if p126.i % 2 == 1 == (p126.side == "L") then 0 else 0.5) + p126.i * 0.025) + ARENA.STANCE / 2) * ARENA.CYCLE))
    local v466 = v465:PointToWorldSpace(p126.hip)
    local v467 = v465:PointToWorldSpace(p126.tip)
    local v468 = (p126.L1 + p126.L2) * t2.LIMB.LEG.REACH
    local v469

    for _ = 1, 6 do
        v469 = nearestRock(v467)

        if (v469 - v466).Magnitude <= v468 then
            break
        end

        v467 = v466:Lerp(v467, 0.75)
    end

    local t18 = {
        pos = v469
    }

    p123.holds.count = (p123.holds.count or 0) + 1

    if p123.holds.count > 4000 then
        p123.holds = {
            count = 0,
            rise = p124
        }
    end

    p123.holds[v462] = t18

    return t18
end

local function legAt(p128, p129, p130, p131, p132, p133) -- line: 856
    -- upvalues: ARENA (copy), stepHold (copy)
    local v470 = p132 / ARENA.CYCLE - ((if p131.i % 2 == 1 == (p131.side == "L") then 0 else 0.5) + p131.i * 0.025)
    local v471 = math.floor(v470)
    local v472 = v470 - v471
    local v473 = stepHold(p128, p129, p130, p131, v471)

    if v472 < ARENA.STANCE then
        return v473.pos
    end

    local v474 = stepHold(p128, p129, p130, p131, v471 + 1)
    local v475 = (v472 - ARENA.STANCE) / (1 - ARENA.STANCE)
    local pos = v473.pos
    local pos2 = v474.pos
    local v476 = math.clamp(v475, 0, 1)

    return pos:Lerp(pos2, v476 * v476 * (3 - 2 * v476)) + p133 * (ARENA.LIFT * math.sin(3.141592653589793 * v475))
end

local function legDown(p134, p135, p136, p137, p138) -- line: 868
    -- upvalues: ARENA (copy), stepHold (copy)
    local v479 = p138 / ARENA.CYCLE - ((if p137.i % 2 == 1 == (p137.side == "L") then 0 else 0.5) + p137.i * 0.025)
    local v480 = math.floor(v479)
    local v481 = v479 - v480

    if ARENA.STANCE <= v481 and (v481 - ARENA.STANCE) / (1 - ARENA.STANCE) >= 0.5 then
        v480 += 1
    end

    return stepHold(p134, p135, p136, p137, v480).pos
end

local _ = {
    DOWN = 0.15,
    UP = 0.12
}

local function strikeHold(p139, p140, p141, p142) -- line: 879
    -- upvalues: t2 (copy), ARENA (copy), nearestRock (copy), bodyAt (copy)
    p141.holds = p141.holds or {}

    if p141.holds[p142] then
        return p141.holds[p142]
    end

    local v482 = p141.strikes[p142]
    local v483 = p139.claws[v482.side]
    local v484 = bodyAt(p140, v482.at)
    local v485 = v484:PointToWorldSpace(v483.hip)
    local v486 = v485 + v484.LookVector * ARENA.CLAW.AHEAD - v484.UpVector * ARENA.CLAW.IN
    local v487 = (v483.L1 + v483.L2) * t2.LIMB.CLAW.REACH
    local v488, Unit

    for _ = 1, 8 do
        local v489

        v488, v489 = nearestRock(v486)

        local v492 = Vector3.new(v488.X - v485.X, 0, v488.Z - v485.Z)
        local v493 = v492.Magnitude > 0.001
        local Unit2 = if v493 then v492.Unit else nil
        local v494 = if not v493 or not Unit2 then Vector3.new(0, 0, 0) else Unit2

        Unit = (-v489 * 0.75 + v494 * 0.55 - Vector3.new(0, 0.2, 0)).Unit

        if (v488 - Unit * v483.L3 - v485).Magnitude <= v487 then
            break
        end

        v486 = v485:Lerp(v486, 0.75)
    end

    local t19 = {
        pos = v488,
        sd = Unit
    }

    p141.holds[p142] = t19

    return t19
end

local function clawAt(p143, p144, p145, p146, p147, p148, p149, p150) -- line: 904
    -- upvalues: ARENA (copy), swing (copy), strikeHold (copy)
    local v495 = {
        pos = p147:PointToWorldSpace(p145.fly),
        sd = p147:VectorToWorldSpace(p145.flySd)
    }

    if not p148.strikes then
        return v495.pos, v495.sd
    end

    local SWING = ARENA.CLAW.SWING
    local t20 = {}

    for v496, v497 in ipairs(p148.strikes) do
        if v497.side == p145.side then
            t20[#t20 + 1] = v496
        end
    end

    if #t20 == 0 then
        return v495.pos, v495.sd
    end

    if not (p148.release and p148.release <= p146) then
        for v498, v499 in ipairs(t20) do
            local at = p148.strikes[v499].at

            if p146 < at - SWING then
                if v498 == 1 then
                    return v495.pos, v495.sd
                end

                local v500 = strikeHold(p143, p144, p148, t20[v498 - 1])

                return v500.pos, v500.sd
            end

            if p146 < at then
                if v498 ~= 1 or not v495 then
                    v495 = strikeHold(p143, p144, p148, t20[v498 - 1])
                end

                return swing(p145, v495, strikeHold(p143, p144, p148, v499), (p146 - (at - SWING)) / SWING, p149, p150)
            end
        end

        local v501 = strikeHold(p143, p144, p148, t20[#t20])

        return v501.pos, v501.sd
    end

    return swing(p145, strikeHold(p143, p144, p148, t20[#t20]), v495, math.min((p146 - p148.release) / ARENA.CLAW.BACK, 1), p149, p150)
end

local function arenaLimbs(p151, p152, p153, p154, p155) -- line: 928
    -- upvalues: ARENA (copy), surfFrame (copy), runAt (copy), segAt (copy), odoPlace (copy), swing (copy), place (copy), legAt (copy), legDown (copy), strikeHold (copy), clawAt (copy)
    local LookVector = p155.LookVector
    local v504 = segAt(p153, p154)
    local v505 = p153.segs[v504]

    if v505.kind == "jump" then
        local JUMP = ARENA.JUMP
        local v506 = (p154 - v505.t0) / (v505.t1 - v505.t0)
        local v507 = select(2, surfFrame(odoPlace(p153, v505.D)))
        local v508 = select(2, surfFrame(odoPlace(p153, v505.D + 2 * ARENA.CYCLE)))
        local v509 = p153.segs[v504 - 1]

        for _, v510 in ipairs(p151.limbs) do
            local t21 = {
                pos = p155:PointToWorldSpace(v510.fly),
                sd = v510.flySd and p155:VectorToWorldSpace(v510.flySd)
            }
            local pos, sd = t21.pos, t21.sd

            if v506 < JUMP.OFF then
                local v511

                if v510.kind == "leg" then
                    v511 = {
                        pos = legAt(p151, p152, p153, v510, v505.D, v507)
                    }
                elseif v509 and v509.strikes then
                    local v512 = #v509.strikes

                    v511 = t21

                    for i = v512, 1, -1 do
                        if v509.strikes[i].side == v510.side then
                            v511 = strikeHold(p151, p153, v509, i)
                            break
                        end

                        v511 = t21
                    end
                else
                    v511 = t21
                end

                pos, sd = swing(v510, v511, t21, v506 / JUMP.OFF, LookVector, v507)
            elseif JUMP.REACH <= v506 and v510.kind == "leg" then
                pos = swing(v510, t21, {
                    pos = legAt(p151, p152, p153, v510, v505.D + 2 * ARENA.CYCLE, v508)
                }, math.min((v506 - JUMP.REACH) / (1 - JUMP.REACH), 1), LookVector, v508)
            end

            place(v510, p155, pos, sd or t21.sd)
        end
    else
        local v514 = p153.segs[segAt(p153, p154)]
        local v515, v516, v517

        if v514.kind == "run" then
            local v518 = runAt(v514, p154 - v514.t0)

            v515 = v514.th0 + v514.a * v518 / v514.rr
            v516 = v514.v0 + v514.b * v518
            v517 = v514.D0 + v518
        else
            v515 = v514.th
            v516 = v514.v
            v517 = v514.D
        end

        local v519 = select(2, surfFrame(v515, v516))
        local n10 = 0

        if v505.kind == "freeze" then
            local v521 = math.clamp((p154 - v505.t0) / 0.15, 0, 1)

            n10 = v521 * v521 * (3 - 2 * v521)
        elseif v505.kind == "run" then
            if p154 - v505.t0 > v505.dur then
                local v523 = math.clamp((p154 - v505.t0 - v505.dur) / 0.15, 0, 1)

                n10 = v523 * v523 * (3 - 2 * v523)
            elseif p153.segs[v504 - 1] and p153.segs[v504 - 1].kind == "freeze" then
                local v525 = math.clamp((p154 - v505.t0) / 0.12, 0, 1)

                n10 = 1 - v525 * v525 * (3 - 2 * v525)
            end
        end

        for _, v526 in ipairs(p151.limbs) do
            if v526.kind == "leg" then
                local v527 = legAt(p151, p152, p153, v526, v517, v519)

                if n10 > 0 then
                    v527 = v527:Lerp(legDown(p151, p152, p153, v526, v517), n10)
                end

                place(v526, p155, v527)
            else
                place(v526, p155, clawAt(p151, p153, v526, p154, p155, v505, LookVector, v519))
            end
        end
    end
end

t2.TEASE = {
    CENTRE = Vector3.new(50, 0, 0),
    R = 102,
    CEIL = -2107,
    TOP = -2103,
    DEEP = -2270,
    STAND = 32,
    ROUND = 40,
    OFFSET = 14,
    SNAP = 12,
    FOOT = 0.4,
    CYCLE = 40,
    STANCE = 0.55,
    LIFT = 10,
    BOB = 1.2,
    RAMP = 0.3,
    GUARD = Vector3.new(0, 18, -6),
    MAX = 40,
    BREATH = { 0.8, 4.3 },
    SWAY = { 3, 6.1 },
    SPEED = {
        UP = { 30, 40 },
        CREEP = { 14, 22 },
        FLEE = { 45, 60 }
    },
    HANG = { 0.8, 1.6 },
    STOP = { 0.6, 1.3 },
    SETTLE = {
        DOWN = 0.3,
        UP = 0.25
    },
    SLIP = {
        UP = 18,
        MIN_UP = 10,
        DROP = 0.22,
        CATCH = 0.2,
        HOLD = 1.5,
        BACK = 0.5,
        RECOVER = 0.35,
        SAG = 6,
        ROLL = 10,
        KICKS = 3,
        KICK = 5,
        PULL = 8,
        FIT = 1.2,
        SHUDDER = {
            DEG = 1.5,
            HZ = 11,
            DECAY = 0.4
        }
    }
}

local TEASE = t2.TEASE
local v528 = Vector3.new(TEASE.CENTRE.X, 0, TEASE.CENTRE.Z)
local t23 = {}

local function tzSeal(p156) -- line: 1019
    -- upvalues: t23 (ref)
    if t23.seal == p156 then
        return
    end

    t23 = {
        seal = p156
    }

    for _, descendant in ipairs(p156:GetDescendants()) do
        if descendant:IsA("BasePart") and (descendant.Name == "Plank" or descendant.Name == "Board" or descendant.Name == "CrossBoard") then
            local CFrame = descendant.CFrame
            local t24 = t23
            local t25 = t23

            t24[#t25 + 1] = {
                p = CFrame.Position,
                ax = {
                    CFrame.RightVector,
                    CFrame.UpVector,
                    CFrame.LookVector
                },
                h = {
                    descendant.Size.X / 2,
                    descendant.Size.Y / 2,
                    descendant.Size.Z / 2
                }
            }
        end
    end
end

local function tzUnder(p157, p158) -- line: 1031
    -- upvalues: t23 (ref)
    local v530

    for _, v531 in ipairs(t23) do
        local n11 = (-1e999)
        local n12 = 1e999

        for i = 1, 3 do
            local v532 = v531.ax[i]
            local v533 = v531.h[i]
            local v534 = (p157 - v531.p.X) * v532.X + (p158 - v531.p.Z) * v532.Z

            if math.abs(v532.Y) < 1E-06 then
                if v533 < math.abs(v534) then
                    n11 = 1e999
                    break
                end
            else
                local v535 = (-v533 - v534) / v532.Y
                local v536 = (v533 - v534) / v532.Y

                n11 = math.max(n11, (math.min(v535, v536)))
                n12 = math.min(n12, (math.max(v535, v536)))
            end
        end

        if n11 <= n12 then
            v530 = math.min(v530 or 1e999, v531.p.Y + n11)
        end
    end

    return v530
end

local function tzSnap(p159, p160) -- line: 1053
    -- upvalues: TEASE (copy), tzUnder (copy)
    local v541 = tzUnder(p159, p160)

    if v541 then
        return Vector3.new(p159, v541 - TEASE.FOOT, p160), false
    end

    for i = 2, TEASE.SNAP, 2 do
        for j = 0, 11 do
            local v543 = j * 6.283185307179586 / 12
            local v544 = p159 + math.cos(v543) * i
            local v545 = p160 + math.sin(v543) * i
            local v546 = tzUnder(v544, v545)

            if v546 then
                return Vector3.new(v544, v546 - TEASE.FOOT, v545), true
            end
        end
    end

    return Vector3.new(p159, TEASE.CEIL, p160), true
end

local function tzSurface(p161) -- line: 1068
    -- upvalues: TEASE (copy), v528 (copy), tzSnap (copy)
    local v550 = Vector3.new(p161.X - v528.X, 0, p161.Z - v528.Z)
    local Magnitude = v550.Magnitude
    local v551 = Magnitude > 0.001 and v550 / Magnitude or Vector3.new(1, 0, 0)
    local v554 = v528 + v551 * (TEASE.R - TEASE.FOOT) + Vector3.new(0, 1, 0) * math.min(p161.Y, TEASE.CEIL - 4)
    local v556 = v528 + v551 * math.min(Magnitude, TEASE.R - 4)
    local v557, v558 = tzSnap(v556.X, v556.Z)

    if (v554 - p161).Magnitude < (v557 - p161).Magnitude then
        return v554, nil
    end

    return v557, v558 and Vector3.new(v556.X, v557.Y, v556.Z) or nil
end

local function tzPath(p162, p163) -- line: 1080
    -- upvalues: TEASE (copy)
    local v560 = math.clamp(p163, 0, p162.len)
    local ROUND = TEASE.ROUND
    local v561, v562, v563, v564, v565, v566, v567

    if v560 < p162.l1 then
        v566 = p162.uW
        v567 = TEASE.DEEP + v560
        v562 = 0
        v563 = 1
        v564 = 1
        v565 = 0
        v561 = nil
    elseif v560 < p162.l1 + p162.arc then
        v561 = 3.141592653589793 - (v560 - p162.l1) / ROUND
        v566 = p162.uW + ROUND + ROUND * math.cos(v561)
        v567 = p162.yC - ROUND + ROUND * math.sin(v561)
        v562 = nil
        v563 = nil
        v564 = nil
        v565 = nil
    elseif v560 < p162.l1 + p162.arc + p162.l3 then
        v566 = p162.uW + ROUND + (v560 - p162.l1 - p162.arc)
        v567 = p162.yC
        v562 = 1
        v563 = 0
        v564 = 0
        v565 = -1
        v561 = nil
    elseif v560 < p162.l1 + 2 * p162.arc + p162.l3 then
        v561 = 1.5707963267948966 - (v560 - p162.l1 - p162.arc - p162.l3) / ROUND
        v566 = -p162.uW - ROUND + ROUND * math.cos(v561)
        v567 = p162.yC - ROUND + ROUND * math.sin(v561)
        v562 = nil
        v563 = nil
        v564 = nil
        v565 = nil
    else
        v566 = -p162.uW
        v567 = p162.yC - ROUND - (v560 - p162.l1 - 2 * p162.arc - p162.l3)
        v562 = 0
        v563 = -1
        v564 = -1
        v565 = 0
        v561 = nil
    end

    if v561 then
        v562 = math.sin(v561)
        v563 = -math.cos(v561)
        v564 = -math.cos(v561)
        v565 = -math.sin(v561)
    end

    return p162.c0 + p162.h * v566 + Vector3.new(0, 1, 0) * v567, p162.h * v562 + Vector3.new(0, 1, 0) * v563, p162.h * v564 + Vector3.new(0, 1, 0) * v565
end

local function tzMesh(p164, p165, p166, p167, p168) -- line: 1102
    -- upvalues: t2 (copy), tzPath (copy)
    local v568, v569, v570 = tzPath(p164, p165)

    return CFrame.lookAt(v568, v568 + v569, v570) * CFrame.new(0, p166 or 0, 0) * CFrame.Angles(0, p167 or 0, p168 or 0) * CFrame.new(-t2.CENTRE), v569, v570
end

local function tzHold(_, p170, p171, p172) -- line: 1109
    -- upvalues: t2 (copy), TEASE (copy), tzSurface (copy), tzMesh (copy)
    local v571 = p172 * 16 + p171.id
    local v572 = p170.holds[v571]

    if v572 then
        return v572
    end

    local v574 = tzMesh(p170, (p172 + ((if p171.i % 2 == 1 == (p171.side == "L") then 0 else 0.5) + p171.i * 0.025) + TEASE.STANCE / 2) * TEASE.CYCLE)
    local v575 = v574:PointToWorldSpace(p171.hip)
    local v576 = v574:PointToWorldSpace(p171.tip)
    local v577 = (p171.L1 + p171.L2) * t2.LIMB.LEG.REACH
    local v578, v579

    for _ = 1, 6 do
        v578, v579 = tzSurface(v576)

        if (v578 - v575).Magnitude <= v577 then
            break
        end

        v576 = v575:Lerp(v576, 0.75)
    end

    local t27 = {
        pos = v578,
        gap = v579
    }

    p170.holds[v571] = t27

    return t27
end

local function tzOdo(p173, p174) -- line: 1128
    local segs = p173.segs
    local n13 = 1

    while n13 < #segs and segs[n13].t1 <= p174 do
        n13 += 1
    end

    local v580 = segs[n13]

    if v580.kind ~= "run" then
        return v580.d0, v580, n13
    end

    local v581 = v580.t1 - v580.t0
    local v583 = math.clamp(p174 - v580.t0, 0, v581)
    local a = v580.a
    local v584 = if v583 < a then v580.v * v583 * v583 / (2 * a) elseif v583 < v581 - a then v580.v * (v583 - a / 2) else v580.d1 - v580.d0 - v580.v * (v581 - v583) ^ 2 / (2 * a)

    return v580.d0 + v584, v580, n13
end

local function tzFoot(p175, p176, p177, p178, p179) -- line: 1148
    -- upvalues: TEASE (copy), tzHold (copy)
    local v585 = p178 / TEASE.CYCLE - ((if p177.i % 2 == 1 == (p177.side == "L") then 0 else 0.5) + p177.i * 0.025)
    local v586 = math.floor(v585)
    local v587 = v585 - v586
    local pos = tzHold(p175, p176, p177, v586).pos

    if v587 < TEASE.STANCE then
        return pos
    end

    local slip = p176.slip
    local v588, v589

    if slip and slip.L == p177 and slip.n == v586 + 1 then
        local gap = slip.gap

        if gap then
            v588 = gap
            v589 = true
        else
            v589 = false
        end
    else
        v589 = false
    end

    if not v589 then
        v588 = tzHold(p175, p176, p177, v586 + 1).pos
    end

    local v590 = (v587 - TEASE.STANCE) / (1 - TEASE.STANCE)
    local v591 = math.clamp(v590, 0, 1)

    return pos:Lerp(v588, v591 * v591 * (3 - 2 * v591)) + p179 * (TEASE.LIFT * math.sin(3.141592653589793 * v590))
end

local function tzDown(p180, p181, p182, p183) -- line: 1160
    -- upvalues: TEASE (copy), tzHold (copy)
    local v594 = p183 / TEASE.CYCLE - ((if p182.i % 2 == 1 == (p182.side == "L") then 0 else 0.5) + p182.i * 0.025)
    local v595 = math.floor(v594)
    local v596 = v594 - v595

    if TEASE.STANCE <= v596 and (v596 - TEASE.STANCE) / (1 - TEASE.STANCE) >= 0.5 then
        v595 += 1
    end

    return tzHold(p180, p181, p182, v595).pos
end

local function tzEnv(p184) -- line: 1168
    -- upvalues: TEASE (copy)
    local SLIP = TEASE.SLIP

    if p184 < SLIP.DROP then
        local v598 = math.clamp(p184 / SLIP.DROP, 0, 1)

        return v598 * v598 * (3 - 2 * v598)
    end

    local v599 = p184 - SLIP.DROP

    if v599 < SLIP.HOLD then
        local v601 = math.clamp(v599 / 0.5, 0, 1)

        return 1 - 0.6 * (v601 * v601 * (3 - 2 * v601))
    end

    local v603 = math.clamp((v599 - SLIP.HOLD) / (SLIP.BACK + SLIP.RECOVER), 0, 1)

    return 0.4 * (1 - v603 * v603 * (3 - 2 * v603))
end

function t2.TeasePlan(p185, p186, p187) -- line: 1178
    -- upvalues: t2 (copy), TEASE (copy), v528 (copy), t23 (ref), tzSeal (copy), tzUnder (copy), tzSnap (copy), tzPath (copy), tzMesh (copy), tzHold (copy)
    if p186.plan then
        return p186.plan
    end

    if not p187 then
        return nil
    end

    tzSeal(p187)

    if #t23 == 0 then
        return nil
    end

    local v605 = Random.new(math.floor(p186.t0 * 1000) % 2147483646 + 1)
    local v608 = Vector3.new(math.cos(p186.yaw), 0, (math.sin(p186.yaw)))
    local v609 = v605:NextNumber(-TEASE.OFFSET, TEASE.OFFSET)
    local v611 = math.sqrt(TEASE.R * TEASE.R - v609 * v609)
    local t28 = {
        h = v608,
        c0 = v528 + v608:Cross((Vector3.new(0, 1, 0))) * v609,
        uW = -(v611 - TEASE.STAND),
        yC = TEASE.CEIL - TEASE.STAND,
        holds = {}
    }

    t28.l1 = t28.yC - TEASE.ROUND - TEASE.DEEP
    t28.arc = 1.5707963267948966 * TEASE.ROUND
    t28.l3 = 2 * (-t28.uW - TEASE.ROUND)
    t28.len = 2 * (t28.l1 + t28.arc) + t28.l3

    local v612 = t28.l1 + t28.arc
    local v613 = t28.l1 + t28.arc + t28.l3
    local SLIP = TEASE.SLIP
    local v614 = t28.l1 + t28.arc * 0.5
    local n14 = 1e999
    local v615

    for _, v616 in ipairs(p185.limbs) do
        if v616.kind == "leg" then
            local v617 = (if v616.i % 2 == 1 == (v616.side == "L") then 0 else 0.5) + v616.i * 0.025

            for i = math.ceil((v614 + 15) / TEASE.CYCLE - v617), math.floor((v613 + t28.arc * 0.4) / TEASE.CYCLE - v617) do
                local gap = tzHold(p185, t28, v616, i).gap
                local v621 = gap ~= nil
                local _ipairs = ipairs
                local t29 = if v621 then {
                    Vector3.new(SLIP.FIT, 0, 0),
                    Vector3.new(-SLIP.FIT, 0, 0),
                    Vector3.new(0, 0, SLIP.FIT),
                    (Vector3.new(0, 0, -SLIP.FIT))
                } else nil
                local v627 = if not v621 or not t29 then {} else t29

                for _, v628 in _ipairs(v627) do
                    if tzUnder(gap.X + v628.X, gap.Z + v628.Z) then
                        v621 = false
                    end
                end

                local v629 = n14
                local v630 = v615

                if v621 then
                    local v631 = (i + v617) * TEASE.CYCLE
                    local v633 = (if v616.side == "L" then -1 else 1) * math.rad(SLIP.ROLL)
                    local v634 = tzMesh(t28, v631, SLIP.SAG, 0, v633)
                    local v635 = v634:PointToWorldSpace(v616.hip)
                    local v636 = (v616.L1 + v616.L2) * 0.94
                    local Magnitude = Vector3.new(gap.X - v635.X, 0, gap.Z - v635.Z).Magnitude
                    local v643 = math.min(TEASE.TOP + SLIP.UP, v635.Y + math.sqrt((math.max(0, v636 * v636 - Magnitude * Magnitude))) - SLIP.KICK - 1)

                    v629 = Vector3.new(gap.X - v528.X, 0, gap.Z - v528.Z).Magnitude + v605:NextNumber(0, 6)

                    if v643 - TEASE.TOP >= SLIP.MIN_UP and v629 < n14 then
                        v630 = {
                            L = v616,
                            n = i,
                            s = v631,
                            gap = gap
                        }
                        v630.up = Vector3.new(gap.X, v643, gap.Z)
                        v630.top = Vector3.new(gap.X, TEASE.TOP, gap.Z)
                        v630.hold = tzHold(p185, t28, v616, i).pos
                        v630.F = v634
                    else
                        v629 = n14
                    end
                end

                n14 = v629
                v615 = v630
            end
        end
    end

    if v615 then
        local v646 = v615.F:PointToWorldSpace(v615.L.hip)
        local v649 = Vector3.new(v646.X - v615.gap.X, 0, v646.Z - v615.gap.Z)
        local v650 = v649.Magnitude > 0.001 and v649.Unit * 4 or Vector3.new(0, 0, 0)

        v615.hold = tzSnap(v615.gap.X + v650.X, v615.gap.Z + v650.Z)
        t28.holds[v615.n * 16 + v615.L.id] = {
            pos = v615.hold
        }

        local v651 = p185.claws[v615.L.side]
        local v652 = v615.F:PointToWorldSpace(v651.hip)
        local v653 = select(2, tzPath(t28, v615.s))
        local Unit = (Vector3.new(0, 0.85, 0) + Vector3.new(v653.X, 0, v653.Z) * 0.15).Unit
        local v654 = v615.F:PointToWorldSpace(v651.tip + TEASE.GUARD)

        for _ = 1, 6 do
            local v655 = tzSnap(v654.X, v654.Z)

            if (v655 - Unit * v651.L3 - v652).Magnitude <= (v651.L1 + v651.L2) * t2.LIMB.CLAW.REACH then
                v615.claw = v655
                v615.clawSd = Unit
                break
            end

            v654 = Vector3.new(v652.X, v654.Y, v652.Z):Lerp(v654, 0.75)
        end

        v615.F = nil
    end

    t28.slip = v615

    local t30 = {}
    local t0 = p186.t0
    local t31 = {}

    t31[1] = t0

    local n15 = 0

    local function pick(p188) -- line: 1251
        -- upvalues: v605 (copy)
        return v605:NextNumber(p188[1], p188[2])
    end

    local function run(p189, p190) -- line: 1252
        -- upvalues: t30 (copy), t31 (copy), n15 (ref), TEASE (copy)
        local v656 = p189 - n15

        if v656 <= 0.5 then
            return
        end

        local v658 = math.min(TEASE.RAMP, v656 / p190)

        t30[#t30 + 1] = {
            kind = "run",
            t0 = t31[1],
            t1 = t31[1] + v656 / p190 + v658,
            d0 = n15,
            d1 = p189,
            v = p190,
            a = v658
        }
        t31[1] = t31[1] + v656 / p190 + v658
        n15 = p189
    end

    run(v614, pick(TEASE.SPEED.UP))

    local HANG = TEASE.HANG
    local v659, v660 = v605:NextNumber(HANG[1], HANG[2])

    t30[#t30 + 1] = {
        kind = v660 or "stop",
        t0 = t31[1],
        t1 = t31[1] + v659,
        d0 = n15,
        d1 = n15
    }
    t31[1] += v659

    local _ = t30[#t30]
    local s = v615 and v615.s or (v612 + v613) / 2

    if s - n15 > 40 then
        local v661 = (s - n15) * v605:NextNumber(0.4, 0.6)

        run(n15 + v661, pick(TEASE.SPEED.CREEP))

        local STOP = TEASE.STOP
        local v662, v663 = v605:NextNumber(STOP[1], STOP[2])

        t30[#t30 + 1] = {
            kind = v663 or "stop",
            t0 = t31[1],
            t1 = t31[1] + v662,
            d0 = n15,
            d1 = n15
        }
        t31[1] += v662

        local _ = t30[#t30]
    end

    run(s, pick(TEASE.SPEED.CREEP))

    if v615 then
        local v664 = SLIP.DROP + SLIP.HOLD + SLIP.BACK + SLIP.RECOVER

        t30[#t30 + 1] = {
            kind = "slip",
            t0 = t31[1],
            t1 = t31[1] + v664,
            d0 = n15,
            d1 = n15
        }
        t31[1] += v664
        t28.slipSeg = t30[#t30]
    else
        local STOP = TEASE.STOP
        local v665, v666 = v605:NextNumber(STOP[1], STOP[2])

        t30[#t30 + 1] = {
            kind = v666 or "stop",
            t0 = t31[1],
            t1 = t31[1] + v665,
            d0 = n15,
            d1 = n15
        }
        t31[1] += v665

        local _ = t30[#t30]
    end

    run(t28.len, pick(TEASE.SPEED.FLEE))

    local t0_2 = p186.t0
    local v667 = t31[1] - t0_2

    t28.segs = t30
    t28.dur = v667
    p186.plan = t28

    return t28
end

function t2.TeasePose(p191, p192, p193) -- line: 1284
    -- upvalues: place (copy), TEASE (copy), tzMesh (copy), tzOdo (copy), tzFoot (copy), tzDown (copy), tzEnv (copy)
    local v668, v669, v670 = tzOdo(p192, p193)
    local v671 = p193 - v669.t0
    local SLIP = TEASE.SLIP
    local slip = p192.slip
    local v672 = v669.kind == "slip"
    local v673 = v669.kind == "run"
    local v674 = if v673 then -TEASE.BOB * (0.5 - math.cos(12.566370614359172 * v668 / TEASE.CYCLE) * 0.5) else nil

    if not v673 or not v674 then
        v674 = TEASE.BREATH[1] * math.sin(6.283185307179586 * p193 / TEASE.BREATH[2])
    end

    local v679, v680

    if v672 then
        local v681 = tzEnv(v671)
        local v682 = v674 + SLIP.SAG * v681

        v679 = (if slip.L.side == "L" then -1 else 1) * math.rad(SLIP.ROLL) * v681
        v680 = v682

        if SLIP.DROP < v671 then
            v679 += math.rad(SLIP.SHUDDER.DEG) * math.exp(-(v671 - SLIP.DROP) / SLIP.SHUDDER.DECAY) * math.sin(6.283185307179586 * SLIP.SHUDDER.HZ * v671)
        end
    else
        v680 = v674
        v679 = 0
    end

    local v691, v692, v693 = tzMesh(p192, v668, v680, math.rad(TEASE.SWAY[1]) * math.sin(6.283185307179586 * p193 / TEASE.SWAY[2]), v679)
    local v694

    if v669.kind == "run" then
        if v670 > 1 then
            local v696 = math.clamp(v671 / TEASE.SETTLE.UP, 0, 1)

            v694 = 1 - v696 * v696 * (3 - 2 * v696)
        else
            v694 = 0
        end
    else
        local v698 = math.clamp(v671 / TEASE.SETTLE.DOWN, 0, 1)

        v694 = v698 * v698 * (3 - 2 * v698)
    end

    for _, v699 in ipairs(p191.limbs) do
        if v699.kind == "leg" then
            local v700

            if v672 and v699 == slip.L then
                local v701 = v671 - SLIP.DROP

                if v701 < 0 then
                    v700 = slip.gap:Lerp(slip.up, (v671 / SLIP.DROP) ^ 2)
                elseif v701 < SLIP.HOLD then
                    local v702 = 6.283185307179586 * SLIP.KICKS / SLIP.HOLD * v701

                    v700 = slip.up + Vector3.new(0, 1, 0) * (SLIP.KICK * (1 - 0.5 * v701 / SLIP.HOLD) * math.sin(v702)) + v692 * math.sin(v702 * 1.7)
                elseif v701 < SLIP.HOLD + SLIP.BACK then
                    local v705 = (v701 - SLIP.HOLD) / SLIP.BACK
                    local v706 = slip.gap - Vector3.new(0, 1, 0) * SLIP.PULL

                    if v705 < 0.45 then
                        local up = slip.up
                        local v708 = math.clamp(v705 / 0.45, 0, 1)

                        v700 = up:Lerp(v706, v708 * v708 * (3 - 2 * v708))
                    else
                        local v710 = math.clamp((v705 - 0.45) / 0.55, 0, 1)
                        local v711 = v710 * v710 * (3 - 2 * v710)

                        v700 = v706:Lerp(slip.hold, v711) + v693 * (TEASE.LIFT * 0.5 * math.sin(3.141592653589793 * v711))
                    end
                else
                    v700 = slip.hold
                end
            else
                v700 = tzFoot(p191, p192, v699, v668, v693)

                if v694 > 0 then
                    v700 = v700:Lerp(tzDown(p191, p192, v699, v669.d0), v694)
                end
            end

            place(v699, v691, v700)
        else
            local v720 = v691:PointToWorldSpace(v699.tip + TEASE.GUARD + Vector3.new(0, math.sin(6.283185307179586 * p193 / TEASE.BREATH[2]) * 1.5, math.sin(6.283185307179586 * v668 / TEASE.CYCLE + (if v699.side == "L" then 0 else 3.141592653589793)) * 3))
            local v721 = v691:VectorToWorldSpace(v699.sr)

            if v672 and slip.claw and v699.side == slip.L.side then
                local DROP = SLIP.DROP
                local v722 = SLIP.DROP + SLIP.CATCH
                local v723 = SLIP.DROP + SLIP.HOLD + SLIP.BACK * 0.5
                local v724

                if v671 < DROP then
                    v724 = 0
                elseif v671 < v722 then
                    v724 = ((v671 - DROP) / SLIP.CATCH) ^ 2

                    if not v724 then
                        if v671 < v723 then
                            v724 = 1
                        else
                            local v726 = math.clamp((v671 - v723) / 0.45, 0, 1)

                            v724 = 1 - v726 * v726 * (3 - 2 * v726)
                        end
                    end
                elseif v671 < v723 then
                    v724 = 1
                else
                    local v728 = math.clamp((v671 - v723) / 0.45, 0, 1)

                    v724 = 1 - v728 * v728 * (3 - 2 * v728)
                end

                if v724 > 0 then
                    local v729 = v721:Lerp(slip.clawSd, v724)

                    v720 = v720:Lerp(slip.claw, v724)
                    v721 = v729.Magnitude > 0.001 and v729.Unit or slip.clawSd
                end
            end

            place(v699, v691, v720, v721)
        end
    end

    return v691
end

function t2.TeaseEvents(p194, p195, p196, p197) -- line: 1359
    -- upvalues: TEASE (copy), tzHold (copy), tzOdo (copy)
    local t32 = {}
    local v730 = false
    local v731 = false
    local v732 = false
    local v733 = false

    if p197 <= p196 then
        v733 = true
    else
        v730 = true
    end

    if v730 then
        if p197 - p196 > 1 then
            v733 = true
        else
            v731 = true
        end
    end

    v730 = false

    local slip, SLIP

    if v731 then
        slip = p195.slip
        SLIP = TEASE.SLIP

        if slip then
            v730 = true
        else
            v733 = false
        end
    end

    v731 = false

    local t0, v734, t33

    if v730 then
        t0 = p195.slipSeg.t0

        local function at(p198, p199) -- line: 1365
            -- upvalues: p196 (copy), p197 (copy), t32 (copy)
            if p196 < p198 and p198 <= p197 then
                t32[#t32 + 1] = p199
            end
        end

        v734 = t0 + SLIP.DROP * 0.6
        t33 = {
            kind = "punch",
            pos = slip.top,
            side = slip.L.side
        }

        if p196 < v734 then
            v731 = true
        else
            v732 = true
        end
    end

    v730 = false

    if v731 then
        if v734 <= p197 then
            v730 = true
        else
            v732 = true
        end
    end

    v731 = false

    if v730 then
        v732 = true
        t32[#t32 + 1] = t33
    end

    v730 = false

    if v732 then
        if slip.claw then
            v730 = true
        else
            v731 = true
        end
    end

    v732 = false

    local v735, t34

    if v730 then
        v735 = t0 + SLIP.DROP + SLIP.CATCH
        t34 = {
            kind = "claw",
            pos = slip.claw,
            side = slip.L.side
        }

        if p196 < v735 then
            v732 = true
        else
            v731 = true
        end
    end

    v730 = false

    if v732 then
        if v735 <= p197 then
            v730 = true
        else
            v731 = true
        end
    end

    if v730 then
        v731 = true
        t32[#t32 + 1] = t34
    end

    v730 = false

    local v736, t35

    if v731 then
        v736 = t0 + SLIP.DROP + SLIP.HOLD
        t35 = {
            kind = "out",
            pos = slip.top,
            side = slip.L.side
        }

        if p196 < v736 then
            v730 = true
        else
            v733 = false
        end
    end

    v731 = false

    if v730 then
        if v736 <= p197 then
            v731 = true
        else
            v733 = false
        end
    end

    if v731 then
        v733 = false
        t32[#t32 + 1] = t35
    end

    if v733 then
        return t32
    end

    local v737 = tzOdo(p195, p196)
    local v738 = tzOdo(p195, p197)

    if v737 < v738 then
        for _, v739 in ipairs(p194.limbs) do
            if v739.kind == "leg" then
                local v740 = (if v739.i % 2 == 1 == (v739.side == "L") then 0 else 0.5) + v739.i * 0.025

                for i = math.floor(v737 / TEASE.CYCLE - v740) + 1, math.floor(v738 / TEASE.CYCLE - v740) do
                    local pos = tzHold(p194, p195, v739, i).pos

                    if pos.Y > TEASE.CEIL - 16 and (not slip or slip.L ~= v739 or slip.n ~= i) then
                        t32[#t32 + 1] = {
                            kind = "step",
                            pos = pos,
                            side = v739.side
                        }
                    end
                end
            end
        end
    end

    return t32
end

function t2.Pose(p200, p201, p202, p203, p204) -- line: 1391
    -- upvalues: TitanPath (copy), t2 (copy), arenaOf (copy), holdOf (copy), swing (copy), place (copy), arenaLimbs (copy)
    local v744 = p204

    p204 = p204 or TitanPath.Direction(p201)
    v744 = p204

    local v746 = TitanPath.Climb(p201)

    if v746 and TitanPath.cave then
        local v747 = arenaOf(p201, v746, p204)

        if v747.t0 <= p202 then
            return arenaLimbs(p200, p201, v747, p202, p203)
        end
    end

    local v748 = p202 - p201
    local LookVector = p203.LookVector
    local v749 = v746 ~= nil and not TitanPath.cave and v748 < v746.D + 1
    local v750 = v746 and v746.C.FROM + v748 / v746.T or 0
    local v751 = v746 and v746.C.BOUNDS - 1 or 0
    local FLY = t2.LIMB.FLY

    for _, v752 in ipairs(p200.limbs) do
        local t36 = {
            pos = p203:PointToWorldSpace(v752.fly),
            sd = v752.flySd and p203:VectorToWorldSpace(v752.flySd)
        }
        local pos, sd = t36.pos, t36.sd

        if v749 then
            local v753 = math.floor(v750)
            local v754 = v750 - v753

            local function hold(p205) -- line: 1410
                -- upvalues: v744 (ref), p200 (copy), p201 (copy), v746 (copy), v751 (copy), t36 (copy), v752 (copy), holdOf (copy)
                local v756, v757

                if p205 >= 0 and p205 <= v751 then
                    local v758 = holdOf(p200, p201, v746, v752, p205, v744)

                    if v758 then
                        v756 = v758
                        v757 = true
                    else
                        v757 = false
                    end
                else
                    v757 = false
                end

                if not v757 then
                    v756 = t36
                end

                return v756
            end

            if v751 < v753 then
                local v759 = v746.XE + v746.E * (0.15 + 0.06 * (v752.id - 1))

                if v748 < v759 then
                    pos = (v751 >= 0 and v751 <= v751 and holdOf(p200, p201, v746, v752, v751, v744) or t36).pos
                    sd = (v751 >= 0 and v751 <= v751 and holdOf(p200, p201, v746, v752, v751, v744) or t36).sd
                else
                    pos, sd = swing(v752, v751 >= 0 and v751 <= v751 and holdOf(p200, p201, v746, v752, v751, v744) or t36, t36, math.min((v748 - v759) / FLY.BLEND, 1), LookVector)
                end
            elseif v754 < v752.lift then
                local v762 = v753 - 1

                pos = (v762 >= 0 and v762 <= v751 and holdOf(p200, p201, v746, v752, v762, v744) or t36).pos

                local v763 = v753 - 1

                sd = (v763 >= 0 and v763 <= v751 and holdOf(p200, p201, v746, v752, v763, v744) or t36).sd
            elseif v754 < v752.land then
                local v764 = v753 - 1

                pos, sd = swing(v752, v764 >= 0 and v764 <= v751 and holdOf(p200, p201, v746, v752, v764, v744) or t36, v753 >= 0 and v753 <= v751 and holdOf(p200, p201, v746, v752, v753, v744) or t36, (v754 - v752.lift) / (v752.land - v752.lift), LookVector)
            else
                pos = (v753 >= 0 and v753 <= v751 and holdOf(p200, p201, v746, v752, v753, v744) or t36).pos
                sd = (v753 >= 0 and v753 <= v751 and holdOf(p200, p201, v746, v752, v753, v744) or t36).sd
            end
        end

        place(v752, p203, pos, sd or t36.sd)
    end
end

function t2.Landings(p206, p207, p208, p209, p210) -- line: 1433
    -- upvalues: TitanPath (copy), t2 (copy), ARENA (copy), segAt (copy), arenaOf (copy), holdOf (copy), strikeHold (copy)
    local v767 = TitanPath.Climb(p207)

    if not v767 then
        return {}
    end

    if TitanPath.cave then
        local v768 = arenaOf(p207, v767, p210 or TitanPath.Direction(p207))

        if p209 < v768.t0 or p209 <= p208 or p209 - p208 > 1 then
            return {}
        end

        local t37 = {}

        for i = math.max(1, segAt(v768, (math.max(p208, v768.t0))) - 1), segAt(v768, p209) do
            local v770 = v768.segs[i]

            for v771, v772 in ipairs(v770.strikes or {}) do
                if p208 < v772.at and v772.at <= p209 then
                    t37[#t37 + 1] = {
                        kind = "claw",
                        i = 0,
                        pos = strikeHold(p206, v768, v770, v771).pos,
                        side = v772.side,
                        n = v771
                    }
                end
            end

            if v770.roar and v770.peek then
                local v773 = v770.peek + ARENA.PEEK.RISE

                if p208 < v773 and v773 <= p209 then
                    t37[#t37 + 1] = {
                        kind = "roar"
                    }
                end
            end

            if v770.kind == "jump" and p208 < v770.t1 and v770.t1 <= p209 then
                t37[#t37 + 1] = {
                    kind = "leg",
                    side = "L",
                    i = 3,
                    n = 0,
                    pos = v770.B:PointToWorldSpace(t2.CENTRE)
                }
            end
        end

        return t37
    end

    local v774 = v767.C.FROM + (p208 - p207) / v767.T
    local v775 = v767.C.FROM + (p209 - p207) / v767.T

    if v775 <= v774 or v775 - v774 > 1 then
        return {}
    end

    p210 = p210 or TitanPath.Direction(p207)

    local t38 = {}

    for _, v777 in ipairs(p206.limbs) do
        for j = math.max(0, (math.floor(v774 - v777.land))), math.min(v767.C.BOUNDS - 1, (math.floor(v775 - v777.land))) do
            local v784 = j + v777.land

            if v774 < v784 and v784 <= v775 then
                t38[#t38 + 1] = {
                    pos = holdOf(p206, p207, v767, v777, j, p210).pos,
                    kind = v777.kind,
                    side = v777.side,
                    i = v777.i,
                    n = j
                }
            end
        end
    end

    return t38
end

return t2

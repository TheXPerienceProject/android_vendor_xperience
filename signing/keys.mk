# Copyright (C) 2021 The Proton AOSP Project
# Copyright (C) 2021 The XPerience Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Key migration

# AOSP test keys (build/make/target/product/security)
# ADDITIONAL_SYSTEM_PROPERTIES += \
#	ro.build.certs.test.media=308204a830820390a003020102020900f2b98e6123572c4e300d06092a864886f70d0101040500308194310b3009060355040613025553311330110603550408130a43616c69666f726e6961311630140603550407130d4d6f756e7461696e20566965773110300e060355040a1307416e64726f69643110300e060355040b1307416e64726f69643110300e06035504031307416e64726f69643122302006092a864886f70d0109011613616e64726f696440616e64726f69642e636f6d301e170d3038303431353233343035375a170d3335303930313233343035375a308194310b3009060355040613025553311330110603550408130a43616c69666f726e6961311630140603550407130d4d6f756e7461696e20566965773110300e060355040a1307416e64726f69643110300e060355040b1307416e64726f69643110300e06035504031307416e64726f69643122302006092a864886f70d0109011613616e64726f696440616e64726f69642e636f6d30820120300d06092a864886f70d01010105000382010d00308201080282010100ae250c5a16ef97fc2869ac651b3217cc36ba0e86964168d58a049f40ce85867123a3ffb4f6d949c33cf2da3a05c23eacaa57d803889b1759bcf59e7c6f21890ae25085b7ed56aa626c0989ef9ccd36362ca0e8d1b9603fd4d8328767926ccc090c68b775ae7ff30934cc369ef2855a2667df0c667fd0c7cf5d8eba655806737303bb624726eabaedfb72f07ed7a76ab3cb9a381c4b7dcd809b140d891f00213be401f58d6a06a61eadc3a9c2f1c6567285b09ae09342a66fa421eaf93adf7573a028c331d70601ab3af7cc84033ece7c772a3a5b86b0dbe9d777c3a48aa9801edcee2781589f44d9e4113979600576a99410ba81091259dad98c6c68ff784b8f020103a381fc3081f9301d0603551d0e04160414ca293caa8bc0ed3e542eef4205a2bff2b57e4d753081c90603551d230481c13081be8014ca293caa8bc0ed3e542eef4205a2bff2b57e4d75a1819aa48197308194310b3009060355040613025553311330110603550408130a43616c69666f726e6961311630140603550407130d4d6f756e7461696e20566965773110300e060355040a1307416e64726f69643110300e060355040b1307416e64726f69643110300e06035504031307416e64726f69643122302006092a864886f70d0109011613616e64726f696440616e64726f69642e636f6d820900f2b98e6123572c4e300c0603551d13040530030101ff300d06092a864886f70d0101040500038201010084de9516d5e4a87217a73da8487048f53373a5f733f390d61bdf3cc9e5251625bfcaa7c3159cae275d172a9ae1e876d5458127ac542f68290dd510c0029d8f51e0ee156b7b7b5acdb394241b8ec78b74e5c42c5cafae156caf5bd199a23a27524da072debbe378464a533630b0e4d0ffb7e08ecb701fadb6379c74467f6e00c6ed888595380792038756007872c8e3007af423a57a2cab3a282869b64c4b7bd5fc187d0a7e2415965d5aae4e07a6df751b4a75e9793c918a612b81cd0b628aee0168dc44e47b10d3593260849d6adf6d727dc24444c221d3f9ecc368cad07999f2b8105bc1f20d38d41066cc1411c257a96ea4349f5746565507e4e8020a1a81 \
#	ro.build.certs.test.networkstack=308205dc308203c4a003020102020900fc6cb0d8a6fdd168300d06092a864886f70d01010b0500308181310b30090603550406130255533113301106035504080c0a43616c69666f726e69613116301406035504070c0d4d6f756e7461696e20566965773110300e060355040a0c07416e64726f69643110300e060355040b0c07416e64726f69643121301f06035504030c18636f6d2e616e64726f69642e6e6574776f726b737461636b3020170d3139303231323031343632305a180f34373537303130383031343632305a308181310b30090603550406130255533113301106035504080c0a43616c69666f726e69613116301406035504070c0d4d6f756e7461696e20566965773110300e060355040a0c07416e64726f69643110300e060355040b0c07416e64726f69643121301f06035504030c18636f6d2e616e64726f69642e6e6574776f726b737461636b30820222300d06092a864886f70d01010105000382020f003082020a0282020100bb71f5137ff0b2d757acc2ca3d378e0f8de11090d5caf3d49e314d35c283b778b02d792d8eba440364ca970985441660f0bc00afbc63dd611b1bf51ad28a1edd21e0048f548b80f8bd113e25682822f57dab8273afaf12c64d19a0c6be238f3e66ddc79b10fd926931e3ee60a7bf618644da3c2c4fc428139d45d27beda7fe45e30075b493ead6ec01cdd55d931c0a657e2e59742ca632b6dc3842a2deb7d22443c809291d7a549203ae6ae356582a4ca23f30f0549c4ec8408a75278e95c69e8390ad5280bcefaef6f1309a41bd9f3bfb5d12dca7e79ec6fd6848193fa9ab728224887b4f93e985ec7cbf6401b0e863a4b91c05d046f040fe954004b1645954fcb4114cee1e8b64b47d719a19ef4c001cb183f7f3e166e43f56d68047c3440da34fdf529d44274b8b2f6afb345091ad8ad4b93bd5c55d52286a5d3c157465db8ddf62e7cdb6b10fb18888046afdd263ae6f2125d9065759c7e42f8610a6746edbdc547d4301612eeec3c3cbd124dececc8d38b20e73b13f24ee7ca13a98c5f61f0c81b07d2b519749bc2bcb9e0949aef6c118a3e8125e6ab57fce46bb091a66740e10b31c740b891900c0ecda9cc69ecb4f3369998b175106dd0a4ffd7024eb7e75fedd1a5b131d0bb2b40c63491e3cf86b8957b21521b3a96ed1376a51a6ac697866b0256dee1bcd9ab9a188bf4ced80b59a5f24c2da9a55eb7b0e502116e30203010001a3533051301d0603551d0e041604149383c92cfbf099d5c47b0c3657d8622a084b72e1301f0603551d230418301680149383c92cfbf099d5c47b0c3657d8622a084b72e1300f0603551d130101ff040530030101ff300d06092a864886f70d01010b050003820201006a0501382fde2a6b8f70c60cd1b8ee4f788718c288b170258ef3a96230b65005650d6a4c42a59a97b2ddec502413e7b438fbd060363d74b74a232382a7f77fd3da34e38f79fad035a8b472c5cff365818a0118d87fa1e31cc7ed4befd27628760c290980c3cc3b7ff0cfd01b75ff1fcc83e981b5b25a54d85b68a80424ac26015fb3a4c754969a71174c0bc283f6c88191dced609e245f5938ffd0ad799198e2d0bf6342221c1b0a5d332ed2fffc668982cabbcb7d3b630ff8476e5c84ac0ad37adf9224035200039f95ec1fa95bf83796c0e8986135cee2dcaef190b249855a7e7397d4a0bf17ea63d978589c6b48118a381fffbd790c44d80233e2e35292a3b5533ca3f2cc173f85cf904adfe2e4e2183dc1eba0ebae07b839a81ff1bc92e292550957c8599af21e9c0497b9234ce345f3f508b1cc872aa55ddb5e773c5c7dd6577b9a8b6daed20ae1ff4b8206fd9f5c8f5a22ba1980bef01ae6fcb2659b97ad5b985fa81c019ffe008ddd9c8130c06fc6032b2149c2209fc438a7e8c3b20ce03650ad31c4ee48f169777a0ae182b72ca31b81540f61f167d8d7adf4f6bb2330ff5c24037245000d8172c12ab5d5aa5890b8b12db0f0e7296264eb66e7f9714c31004649fb4b864005f9c43c80db3f6de52fd44d6e2036bfe7f5807156ed5ab591d06fd6bb93ba4334ea2739af8b41ed2686454e60b666d10738bb7ba88001 \
#	ro.build.certs.test.platform=308204a830820390a003020102020900b3998086d056cffa300d06092a864886f70d0101040500308194310b3009060355040613025553311330110603550408130a43616c69666f726e6961311630140603550407130d4d6f756e7461696e20566965773110300e060355040a1307416e64726f69643110300e060355040b1307416e64726f69643110300e06035504031307416e64726f69643122302006092a864886f70d0109011613616e64726f696440616e64726f69642e636f6d301e170d3038303431353232343035305a170d3335303930313232343035305a308194310b3009060355040613025553311330110603550408130a43616c69666f726e6961311630140603550407130d4d6f756e7461696e20566965773110300e060355040a1307416e64726f69643110300e060355040b1307416e64726f69643110300e06035504031307416e64726f69643122302006092a864886f70d0109011613616e64726f696440616e64726f69642e636f6d30820120300d06092a864886f70d01010105000382010d003082010802820101009c780592ac0d5d381cdeaa65ecc8a6006e36480c6d7207b12011be50863aabe2b55d009adf7146d6f2202280c7cd4d7bdb26243b8a806c26b34b137523a49268224904dc01493e7c0acf1a05c874f69b037b60309d9074d24280e16bad2a8734361951eaf72a482d09b204b1875e12ac98c1aa773d6800b9eafde56d58bed8e8da16f9a360099c37a834a6dfedb7b6b44a049e07a269fccf2c5496f2cf36d64df90a3b8d8f34a3baab4cf53371ab27719b3ba58754ad0c53fc14e1db45d51e234fbbe93c9ba4edf9ce54261350ec535607bf69a2ff4aa07db5f7ea200d09a6c1b49e21402f89ed1190893aab5a9180f152e82f85a45753cf5fc19071c5eec827020103a381fc3081f9301d0603551d0e041604144fe4a0b3dd9cba29f71d7287c4e7c38f2086c2993081c90603551d230481c13081be80144fe4a0b3dd9cba29f71d7287c4e7c38f2086c299a1819aa48197308194310b3009060355040613025553311330110603550408130a43616c69666f726e6961311630140603550407130d4d6f756e7461696e20566965773110300e060355040a1307416e64726f69643110300e060355040b1307416e64726f69643110300e06035504031307416e64726f69643122302006092a864886f70d0109011613616e64726f696440616e64726f69642e636f6d820900b3998086d056cffa300c0603551d13040530030101ff300d06092a864886f70d01010405000382010100572551b8d93a1f73de0f6d469f86dad6701400293c88a0cd7cd778b73dafcc197fab76e6212e56c1c761cfc42fd733de52c50ae08814cefc0a3b5a1a4346054d829f1d82b42b2048bf88b5d14929ef85f60edd12d72d55657e22e3e85d04c831d613d19938bb8982247fa321256ba12d1d6a8f92ea1db1c373317ba0c037f0d1aff645aef224979fba6e7a14bc025c71b98138cef3ddfc059617cf24845cf7b40d6382f7275ed738495ab6e5931b9421765c491b72fb68e080dbdb58c2029d347c8b328ce43ef6a8b15533edfbe989bd6a48dd4b202eda94c6ab8dd5b8399203daae2ed446232e4fe9bd961394c6300e5138e3cfd285e6e4e483538cb8b1b357 \
#	ro.build.certs.test.shared=308204a830820390a003020102020900f2a73396bd38767a300d06092a864886f70d0101040500308194310b3009060355040613025553311330110603550408130a43616c69666f726e6961311630140603550407130d4d6f756e7461696e20566965773110300e060355040a1307416e64726f69643110300e060355040b1307416e64726f69643110300e06035504031307416e64726f69643122302006092a864886f70d0109011613616e64726f696440616e64726f69642e636f6d301e170d3038303732333231353735395a170d3335313230393231353735395a308194310b3009060355040613025553311330110603550408130a43616c69666f726e6961311630140603550407130d4d6f756e7461696e20566965773110300e060355040a1307416e64726f69643110300e060355040b1307416e64726f69643110300e06035504031307416e64726f69643122302006092a864886f70d0109011613616e64726f696440616e64726f69642e636f6d30820120300d06092a864886f70d01010105000382010d00308201080282010100c8c2dbfd094a2df45c3ff1a32ed21805ec72fc58d017971bd0f6b52c262d70819d191967e158dfd3a2c7f1b3e0e80ce545d79d2848220211eb86f0fd8312d37b420c113750cc94618ae872f4886463bdc4627caa0c0483c86493e3515571170338bfdcc4cd6addd1c0a2f35f5cf24ed3e4043a3e58e2b05e664ccde12bcb67735fd6df1249c369e62542bc0a4729e53917f5c38ffa52d17b73c9c73798ddb18ed481590875547e66bfc5daca4c25a6eb960ed96923709da302ba646cb496b325e86c5c8b2e7a3377b2bbe4c7cf33254291163f689152ac088550c83c508f4bf5adf0aed5a2dca0583f9ab0ad17650db7eea4b23fdb45885547d0feab72183889020103a381fc3081f9301d0603551d0e04160414cb4c7e2cdbb3f0ada98dab79968d172e9dbb1ed13081c90603551d230481c13081be8014cb4c7e2cdbb3f0ada98dab79968d172e9dbb1ed1a1819aa48197308194310b3009060355040613025553311330110603550408130a43616c69666f726e6961311630140603550407130d4d6f756e7461696e20566965773110300e060355040a1307416e64726f69643110300e060355040b1307416e64726f69643110300e06035504031307416e64726f69643122302006092a864886f70d0109011613616e64726f696440616e64726f69642e636f6d820900f2a73396bd38767a300c0603551d13040530030101ff300d06092a864886f70d0101040500038201010040a8d096997959e917a36c44246b6bac2bae05437ecd89794118f7834720352d1c6f8a39b0869942f4da65981faa2951d33971129ec1921d795671c527d6e249f252829faf5b591310311e2de096500d568ad4114a656dc34a8c6f610453afc1ea7992dba4aa7b3f8543a6e35c0728de77fe97eeac83771fd0ec90f8e4449434ee0b6045783e70c7a2e460249260e003cf7608dc352a4c9ef706def4b26050e978ae2fffd7a3323787014915eb3cc874fcc7a9ae930877c5c8c7d1c2e2a8ee863c89180d1855cedba400e7ba43cccaa7243d397e7c0e8e8e4d7d4f92b6bbead49c0cf018069eddca2e7e2fb4668d89dbbd7950d0cd254180fa1eaafc2a556f84

# Official XPerience release keys
#ADDITIONAL_SYSTEM_PROPERTIES += \
#	ro.build.certs.release.media=308204353082031da003020102021452b11df0e863a3affc679052510e789eba3c4690300d06092a864886f70d01010b05003081a9310b3009060355040613024d58310f300d06035504080c064d657869636f3112301006035504070c094d6963686f6163616e311e301c060355040a0c15546865205850657269656e63652050726f6a656374311e301c060355040b0c15546865205850657269656e63652050726f6a6563743112301006035504030c095850657269656e63653121301f06092a864886f70d01090116126b6c6f7a7a37303740676d61696c2e636f6d301e170d3139303932343233353234345a170d3437303230393233353234345a3081a9310b3009060355040613024d58310f300d06035504080c064d657869636f3112301006035504070c094d6963686f6163616e311e301c060355040a0c15546865205850657269656e63652050726f6a656374311e301c060355040b0c15546865205850657269656e63652050726f6a6563743112301006035504030c095850657269656e63653121301f06092a864886f70d01090116126b6c6f7a7a37303740676d61696c2e636f6d30820122300d06092a864886f70d01010105000382010f003082010a0282010100f3dec5e70ff16b2d123934f489b5ca16675261d25d14e97844dd4358c5d044288c5fda6576d94d2adb61a40d4f06212232a2b78f5b31502e877fb993e59ae14b06bd285a6b2ae6b8905c4e29cb1b45a2b1fc850ed8259737212a7482b887e26f3c2f1b7fbe5ce55acf74be2017e697d9152b37c141872520447811fb9fcb01814ddaeef756faaff3fe323e6f3f7a86f10a759c8bd8064bceff37294c4e9499d86d98bf84fb3fe91ae705f5b4f6fee1bf2174c54e62895eca5e3742b66acf39f182a0998659dad9e3a9ccbeba86dc2d9828a808e80e7c49f98658d45e167b65517d8c1969c4c51c040e20b23e8efbfcf7872b7393a22be3bdcb98793f49140af30203010001a3533051301d0603551d0e04160414f9c125e8df63ea9b79f4503c0e5269c1650d3f1a301f0603551d23041830168014f9c125e8df63ea9b79f4503c0e5269c1650d3f1a300f0603551d130101ff040530030101ff300d06092a864886f70d01010b05000382010100c7b114faa54cf5d23392060009879c4bbd12b3cba125893c1a211ec76c26f118b0ff6b13a4e4f4e196c4cc7c5df3169b63c75605a8bee165067dbbcd38fb5823c52eae235fb927f13ba48a93d68903a625af5c4ff59f8f6e45df0fdc10878ac53f0d049969fcb155a15a7454405f48cae754b42f54107b458ef775a547addac24d0b5339d0d9de8eb541ac739f504c6108d9cf4f3b9719aa771a40a2cb65919851a8f1b9b3f864a610e4d5e328f2ace07bc43fcfbee31a9d6870c918e86f4bef80a61f4c72ccd0d4ade548f050c204ea3ee629e695d7582e81add40d84dafa80250726fd6d37f4a0540a039603c286eab72c22af847942c2a24be88c1077a547 \
#	ro.build.certs.release.networkstack=308204353082031da00302010202141976d86b4c96e31b95bfda231926c71ad7d7ca38300d06092a864886f70d01010b05003081a9310b3009060355040613024d58310f300d06035504080c064d657869636f3112301006035504070c094d6963686f6163616e311e301c060355040a0c15546865205850657269656e63652050726f6a656374311e301c060355040b0c15546865205850657269656e63652050726f6a6563743112301006035504030c095850657269656e63653121301f06092a864886f70d01090116126b6c6f7a7a37303740676d61696c2e636f6d301e170d3139303932343233353230335a170d3437303230393233353230335a3081a9310b3009060355040613024d58310f300d06035504080c064d657869636f3112301006035504070c094d6963686f6163616e311e301c060355040a0c15546865205850657269656e63652050726f6a656374311e301c060355040b0c15546865205850657269656e63652050726f6a6563743112301006035504030c095850657269656e63653121301f06092a864886f70d01090116126b6c6f7a7a37303740676d61696c2e636f6d30820122300d06092a864886f70d01010105000382010f003082010a0282010100b5499e5767ec5c3eb9df783e5be567913468008ec9087755ed2ec84687c04a8526ff9524670a24c36af83652f66ca359487a5b5e05348239b1ef175afaf10662d738aad238de8bcba9722aa9af436286766953790bf14704b186ee111482d5bd852eb608e9215c6f99aca9bea59e95e318d1c40cb0d50eda63b97ba89d9433c6eca5d0f90815ed5f79d75448e4fb0d74cdcf4c22cb5eab6e0bc0cbaaf64e92a91c9100840e7ed01826361eac7ed99852ccd228a8bf45d75873ee3ef2a3f1bf2e54371e67bacb6ea67a413a4491fb19874b49f5c5ed1a715d695e4d2108c7747a09f634c3960c4868ca5fd59ddc71f5dc72466827a5464032aec43f2bf8cbcc550203010001a3533051301d0603551d0e04160414b7baead93f0498a5e90fecee28e6d7739bd74f42301f0603551d23041830168014b7baead93f0498a5e90fecee28e6d7739bd74f42300f0603551d130101ff040530030101ff300d06092a864886f70d01010b0500038201010062e6e910674fb4bfcdf417cff8a927b9a3645305f09d1925fdb8dc5875e88ff20a5ee99811eadf0ca647793280b66b3d3a33113b010cf6d219886758d68a2884303f9782c0341ff8ff04c756b463222a8c2054f784d4ba9d1c11c1e81c249fc6b5b7d753239f1c140906ae5ee200d82a5ecabd06fb65320004e81a5deaf92f35679e0fc6bdefac2e0cb92fef0df7854fa938b8e2c5f4d38b5b80081eb3cfa7bd82e5a873364f2863b26c347c23e9df70b940ea88f21fb58666e9ad78ed97e39f76ddb059872793aa046869612b7c5231c8e35de279c4f6b48013dfcb603b95c97d714349e097785fe326c43b45e164acdc59863ce3bea284684423a164497bae \
#	ro.build.certs.release.platform=308204353082031da00302010202141d2ab96e6caed19d837457fb2547e756458bed93300d06092a864886f70d01010b05003081a9310b3009060355040613024d58310f300d06035504080c064d657869636f3112301006035504070c094d6963686f6163616e311e301c060355040a0c15546865205850657269656e63652050726f6a656374311e301c060355040b0c15546865205850657269656e63652050726f6a6563743112301006035504030c095850657269656e63653121301f06092a864886f70d01090116126b6c6f7a7a37303740676d61696c2e636f6d301e170d3139303932343233353331335a170d3437303230393233353331335a3081a9310b3009060355040613024d58310f300d06035504080c064d657869636f3112301006035504070c094d6963686f6163616e311e301c060355040a0c15546865205850657269656e63652050726f6a656374311e301c060355040b0c15546865205850657269656e63652050726f6a6563743112301006035504030c095850657269656e63653121301f06092a864886f70d01090116126b6c6f7a7a37303740676d61696c2e636f6d30820122300d06092a864886f70d01010105000382010f003082010a0282010100cb427b332d0a3cd6d29bfb8258a62f2809a0031013fb88a047cacc358cff25b99ba7675bc43f15513f91adffb7c9528d6456c3d9b6e517d70743285cc362a4c6db1ce413d563e2d6babfbff52072f13a0bdf632f0ec6c2be5fdfa04a6b5b3fe4cbf3ee2a69fef04e0e81091062bfe8e54203fd19116897f0d9c042749a95768e337f5d4e18872d79cc443c06c92149b0b0b5b97e0ff30e8c0226ec381b2c8ffa7bd864cdb230a725fa3bd0ed87d95ea4224a67d4c8d84daabfe242bfc0398c7fded9d40c01487cdbcdb5dd45308e7171631df7429c34c3cd923914984e93cae700332a82d2fd6f03e8fb3b2b66585b38b2700d72ef970665c3c364e0e3245bfb0203010001a3533051301d0603551d0e0416041480e07be2de890241bf084760712bf29145933ce5301f0603551d2304183016801480e07be2de890241bf084760712bf29145933ce5300f0603551d130101ff040530030101ff300d06092a864886f70d01010b05000382010100315cc2592817afe0cd031deef439bfa4a23089a9e92dd54f69fe9ab19800ab812816e501c84319c02cbd9385ee550179e3da581f30caa2042da60a14ef357fb94575af351185b4b8bbb24816222022e6648593e6da51662c33df209b4c8edaf0a2bc0b771faebe69c9e3cc1bdea5ae5a35e4a5222483e904ddb98007807cbec66d0df233953017cf9a76f148d82bcba726672d0776736d99bffce8268ce39f4475baa3951e817daa2a042c43d013f8de718c2db943a35b8cb09e5ab8488d2ef3ab9a253458e9a3d62a1edc50aebc29d27a1a8e0272e5c7c283e9834faaf1c093378c3c9f1c4b3e1b987b7bc5f7bd7abd28f8194fd882b01aac038ca310278db2 \
#	ro.build.certs.release.shared=3082042930820311a0030201020209008d5f30d12d949ea0300d06092a864886f70d01010b05003081aa310b3009060355040613024d58310f300d06035504080c064d657869636f3113301106035504070c0a4d6963686f6163616e20311e301c060355040a0c15546865205850657269656e63652050726f6a656374311e301c060355040b0c15546865205850657269656e63652050726f6a6563743112301006035504030c095850657269656e63653121301f06092a864886f70d01090116126b6c6f7a7a37303740676d61696c2e636f6d301e170d3137303631303030343834355a170d3434313032363030343834355a3081aa310b3009060355040613024d58310f300d06035504080c064d657869636f3113301106035504070c0a4d6963686f6163616e20311e301c060355040a0c15546865205850657269656e63652050726f6a656374311e301c060355040b0c15546865205850657269656e63652050726f6a6563743112301006035504030c095850657269656e63653121301f06092a864886f70d01090116126b6c6f7a7a37303740676d61696c2e636f6d30820122300d06092a864886f70d01010105000382010f003082010a0282010100a4b666a901f1bb55ea0b259d97db7b0d7bd148d8e6e63598565d724c19cacbe85fee9aba9bb75e9d5d51be4671db23d2f82e4b09c1ef1bb5c468f1334fb06937017cc6558a82617240e197ad54e60e8b13dee6eaab2ddf4defa934e3b353817684aec62cac1a8a306e447f569d627561c53c847316b4b3d34227e518b180915d6637bfc8b50c54ff30dafc18fe445b13ea3d4ecb8c92fcae69b85a53ef08c72bd0d654ed9a13842b9498edc767977603169e40dbbfd8b3d22f70face9111c124f2fe2f809948dd2a4080899bd2a07f88541fe8d188bbfc69dd5c5fe59a728a6baa4e709e715b846d38824459b522f78a763cf957caad4213bef0401dc797ce950203010001a350304e301d0603551d0e041604149a4fd468233e37d2d0e35f33a808a474ba657169301f0603551d230418301680149a4fd468233e37d2d0e35f33a808a474ba657169300c0603551d13040530030101ff300d06092a864886f70d01010b050003820101007c119f0f93b8c804f9cbdc52c0dcb4715f44f989e081d6d1ff7b746ef63876e55a0d62c674c73cf27b77dc914be48e01d211ca12c6a14b2054b6dba108ee21df1a0f05ed7af64f8c0f2c3e34a325ffac385ef9d08a9ab88b194924d01db69116a6e1132bfa37ba6cac9a497329762bba6b780e1e8e97e81bee098daf8646d60f016a924993d551e7da8624760c0c44ba1b1974986eb495c6952b4f9383ace2ba445eed3c49563823adb5e13eda353484c25003accfeda892bfceed7904ff21350426a4ee990813b2839ab685a2fe653bd2e8c8f0ba601d34be7c7ae747c6d5b511b0a166e0287c1004a9941917e695ce9edd59e189d0b8b5e51ec0660dc8903b

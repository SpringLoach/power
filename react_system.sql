/*
 Navicat Premium Data Transfer

 Source Server         : cool_link
 Source Server Type    : MySQL
 Source Server Version : 80029
 Source Host           : localhost:3306
 Source Schema         : react_system

 Target Server Type    : MySQL
 Target Server Version : 80029
 File Encoding         : 65001

 Date: 24/10/2022 21:32:11
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for hero_list
-- ----------------------------
DROP TABLE IF EXISTS `hero_list`;
CREATE TABLE `hero_list`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `cname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `title` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `occupation` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `skinName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `infoUrl` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `heroImg` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `faceImg` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `createAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updateAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 122 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hero_list
-- ----------------------------
INSERT INTO `hero_list` VALUES (15, '鲁班七号', '机关造物', '射手', '机关造物|木偶奇遇记|福禄兄弟|电玩小子|星空梦想', '//pvp.qq.com/act/a20180905herostory/index.html?id=112&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/175711332695893.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/43936199005239.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (16, '廉颇', '正义爆轰', '坦克', '正义爆轰|地狱岩魂', '//pvp.qq.com/act/a20180905herostory/index.html?id=105&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20200428/80750919757873.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20200428/117411278918332.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (17, '赵云', '苍天翔龙', '战士/刺客', '苍天翔龙|忍●炎影|未来纪元|皇家上将|嘻哈天王|白执事|引擎之心', '//pvp.qq.com/act/a20180905herostory/index.html?id=107&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/422841175180785.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190116/225211269527745.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (18, '小乔', '恋之微风', '法师', '恋之微风|万圣前夜|天鹅之梦|纯白花嫁|缤纷独角兽', '//pvp.qq.com/act/a20180905herostory/index.html?id=106&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/237121077716001.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190116/1102737314499.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (19, '墨子', '和平守望', '法师/战士', '和平守望|金属风暴|龙骑士|进击墨子号', '//pvp.qq.com/act/a20180905herostory/index.html?id=108&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/62651469219485.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20181025/141381416202595.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (20, '妲己', '魅力之狐', '法师', '魅惑之狐|女仆咖啡|魅力维加斯|仙境爱丽丝|少女阿狸|热情桑巴', '//pvp.qq.com/act/a20180905herostory/index.html?id=109&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/782471528444287.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180327/699631230814498.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (21, '嬴政', '王者独尊', '法师', '王者独尊|摇滚巨星|暗夜贵公子|优雅恋人|白昼王子', '//pvp.qq.com/act/a20180905herostory/index.html?id=110&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20200323/9558902611675.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20200323/278721395811583.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (22, '孙尚香', '千金重弩', '射手', '千金重弩|火炮千金|水果甜心|蔷薇恋人|杀手不太冷|末日机甲|沉稳之力', '//pvp.qq.com/act/a20180905herostory/index.html?id=111&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/528761277746534.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180327/573321328636709.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (23, '庄周', '逍遥梦幻', '辅助/坦克', '逍遥幻梦|鲤鱼之梦|蜃楼王|云端筑梦师', '//pvp.qq.com/act/a20180905herostory/index.html?id=113&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/36407803861490.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/77101394382651.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (24, '刘禅', '暴走机关', '辅助/坦克', '暴走机关|英喵野望|绅士熊喵|天才门将', '//pvp.qq.com/act/a20180905herostory/index.html?id=114&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/6266887523314.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190823/29306987419076.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (25, '高渐离', '叛逆吟游', '法师', '叛逆吟游|金属狂潮|死亡摇滚', '//pvp.qq.com/act/a20180905herostory/index.html?id=115&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/84899525679925.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190116/23817580712911.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (26, '阿轲', '信念之刃', '刺客', '信念之刃|爱心护理|暗夜猫娘|致命风华|节奏热浪', '//pvp.qq.com/act/a20180905herostory/index.html?id=116&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/977331090834512.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20181025/99651112048573.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (27, '钟无艳', '野蛮之锤', '战士/坦克', '野蛮之锤|生化警戒|王者之锤|海滩丽影', '//pvp.qq.com/act/a20180905herostory/index.html?id=117&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/4638371386568.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180327/35122420479789.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (28, '孙膑', '逆流之时', '辅助/法师', '逆流之时|未来旅行|天使之翼|妖精王', '//pvp.qq.com/act/a20180905herostory/index.html?id=118&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/70493764453797.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190717/68582301165891.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (29, '扁鹊', '善恶怪医', '法师', '善恶怪医|救世之瞳|化身博士|炼金王', '//pvp.qq.com/act/a20180905herostory/index.html?id=119&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/59618194648034.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/836271081336597.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (30, '白起', '最终兵器', '坦克', '最终兵器|白色死神|狰|星夜王子', '//pvp.qq.com/act/a20180905herostory/index.html?id=120&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20200326/155221210224517.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20200326/6570235067207.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (31, '芈月', '永恒之月', '法师/坦克', '永恒之月|红桃皇后|大秦宣太后|重明', '//pvp.qq.com/act/a20180905herostory/index.html?id=121&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/4519469508162.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20170613/47620969119925.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (32, '吕布', '无双之魔', '战士/坦克', '无双之魔|圣诞狂欢|天魔缭乱|末日机甲|猎兽之王', '//pvp.qq.com/act/a20180905herostory/index.html?id=123&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/664211000977024.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/321961310548288.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (33, '周瑜', '铁血都督', '法师', '铁血都督|海军大将|真爱至上', '//pvp.qq.com/act/a20180905herostory/index.html?id=124&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/86934792945830.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20170908/307111124323013.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (34, '夏侯惇', '不羁之风', '坦克/战士', '不羁之风|战争骑士|乘风破浪|无限飓风号', '//pvp.qq.com/act/a20180905herostory/index.html?id=126&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/7593351277808.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180327/64439961036621.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (35, '甄姬', '洛神降临', '法师', '洛神降临|冰雪圆舞曲|花好人间|游园惊梦', '//pvp.qq.com/act/a20180905herostory/index.html?id=127&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/8706478784651.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190116/126691414817402.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (36, '曹操', '鲜血枭雄', '战士', '鲜血枭雄|超能战警|幽灵船长|死神来了|烛龙', '//pvp.qq.com/act/a20180905herostory/index.html?id=128&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/128165944821.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/397691359908498.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (37, '典韦', '狂战士', '战士', '狂战士|黄金武士|穷奇', '//pvp.qq.com/act/a20180905herostory/index.html?id=129&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/744831059647720.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/20454559634867.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (38, '宫本武藏', '剑圣', '战士', '剑圣|鬼剑武藏|未来纪元|万象初新|地狱之眼|霸王丸', '//pvp.qq.com/act/a20180905herostory/index.html?id=130&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/46551546090153.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160727/941571076869491.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (39, '李白', '青莲剑仙', '刺客', '青莲剑仙|范海辛|千年之狐|凤求凰|敏锐之力', '//pvp.qq.com/act/a20180905herostory/index.html?id=131&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/54178532140165.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180327/48767445393807.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (40, '马可波罗', '远游之枪', '射手', '远游之枪|激情绿茵|逐梦之星', '//pvp.qq.com/act/a20180905herostory/index.html?id=132&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/213931307900110.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20181029/120341325343790.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (41, '狄仁杰', '断案大师', '射手', '断案大师|锦衣卫|魔术师|超时空战士|阴阳师', '//pvp.qq.com/act/a20180905herostory/index.html?id=133&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/5043088753153.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20181025/64476830268821.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (42, '达摩', '拳僧', '战士/坦克', '拳僧|大发明家|拳王', '//pvp.qq.com/act/a20180905herostory/index.html?id=134&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/48361745905777.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/28376554913969.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (43, '项羽', '霸王', '坦克', '霸王|帝国元帅|苍穹之光|海滩派对|职棒王牌|霸王别姬|科学大爆炸', '//pvp.qq.com/act/a20180905herostory/index.html?id=135&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/640041141757817.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/35024839042519.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (44, '武则天', '女帝', '法师', '女帝|东方不败|海洋之心', '//pvp.qq.com/act/a20180905herostory/index.html?id=136&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/8645575620272.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190627/834011412951609.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (45, '老夫子', '万古长明', '战士', '万古长明|潮流仙人|圣诞老人|功夫老勺', '//pvp.qq.com/act/a20180905herostory/index.html?id=139&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/56207935501606.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/58017735021814.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (46, '关羽', '一骑当千', '战士', '一骑当千|天启骑士|冰锋战神|龙腾万里', '//pvp.qq.com/act/a20180905herostory/index.html?id=140&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/275341569174044.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/18154342091729.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (47, '貂蝉', '绝世舞姬', '法师/刺客', '绝世舞姬|异域舞娘|圣诞恋歌|逐梦之音|仲夏夜之梦', '//pvp.qq.com/act/a20180905herostory/index.html?id=141&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/1559492280407.png', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/55547119153305.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (48, '安琪拉', '暗夜萝莉', '法师', '暗夜萝莉|玩偶对对碰|魔法小厨娘|心灵骇客|如懿', '//pvp.qq.com/act/a20180905herostory/index.html?id=142&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/4412162996520.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/18901316660134.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (49, '程咬金', '热烈之斧', '坦克/战士', '热烈之斧|爱与正义|星际陆战队|华尔街大亨|功夫厨神', '//pvp.qq.com/act/a20180905herostory/index.html?id=144&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/632001118049593.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/12835477027157.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (50, '露娜', '月光之女', '战士/法师', '月光之女|哥特玫瑰|绯红之刃|紫霞仙子|一生所爱', '//pvp.qq.com/act/a20180905herostory/index.html?id=146&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/63581396650488.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190116/119971138563496.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (51, '姜子牙', '太古魔导', '法师/辅助', '太古魔导|时尚教父', '//pvp.qq.com/act/a20180905herostory/index.html?id=148&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/107021158349230.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/21386894863581.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (52, '刘邦', '双面君主', '坦克', '双面君主|圣殿之光|德古拉伯爵', '//pvp.qq.com/act/a20180905herostory/index.html?id=149&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/71567211286504.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190627/1611520684982.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (53, '韩信', '国士无双', '刺客', '国士无双|街头霸王|教廷特使|白龙吟|逐梦之影', '//pvp.qq.com/act/a20180905herostory/index.html?id=150&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/26620610693151.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/558661233757564.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (54, '王昭君', '冰雪之华', '法师', '冰雪之华|精灵公主|偶像歌手|凤凰于飞|幻想奇妙夜', '//pvp.qq.com/act/a20180905herostory/index.html?id=152&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/605981185208690.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20181025/28141313400127.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (55, '兰陵王', '暗影刀锋', '刺客', '暗影刀锋|隐刃|暗隐猎兽者', '//pvp.qq.com/act/a20180905herostory/index.html?id=153&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20210114/34030207140278.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20210114/9912813909230.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (56, '花木兰', '传说之刃', '战士/刺客', '传说之刃|剑舞者|兔女郎|水晶猎龙者|青春决赛季|冠军飞将|瑞麟志', '//pvp.qq.com/act/a20180905herostory/index.html?id=154&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/3685977620263.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20170308/34782968648244.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (57, '张良', '言灵之书', '法师', '言灵之书|天堂福音|一千零一夜|幽兰居士', '//pvp.qq.com/act/a20180905herostory/index.html?id=156&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/2248336605405.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190116/55913224991097.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (58, '不知火舞', '明媚烈焰', '法师/刺客', '明媚烈焰', '//pvp.qq.com/act/a20180905herostory/index.html?id=157&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/579210012886.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/63399584503206.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (59, '娜可露露', '鹰之守护', '刺客', '鹰之守护', '//pvp.qq.com/act/a20180905herostory/index.html?id=162&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/548681020090103.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/31519374723603.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (60, '橘右京', '神梦一刀', '刺客/战士', '神梦一刀', '//pvp.qq.com/act/a20180905herostory/index.html?id=163&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/58109651771952.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160830/20769120063270.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (61, '亚瑟', '圣骑之力', '战士/坦克', '圣骑之力|死亡骑士|狮心王|心灵战警', '//pvp.qq.com/act/a20180905herostory/index.html?id=166&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/45701468188203.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190116/93251107128088.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (62, '孙悟空', '齐天大圣', '刺客/战士', '齐天大圣|地狱火|西部大镖客|美猴王|至尊宝|全息碎影|大圣娶亲', '//pvp.qq.com/act/a20180905herostory/index.html?id=167&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/46014866033037.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/37425581339924.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (63, '牛魔', '精英酋长', '辅助/坦克', '精英酋长|西部大镖客|制霸全明星', '//pvp.qq.com/act/a20180905herostory/index.html?id=168&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/775111569812043.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/873611252975639.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (64, '后羿', '半神之弓', '射手', '半神之弓|精灵王|阿尔法小队|辉光之辰|黄金射手座', '//pvp.qq.com/act/a20180905herostory/index.html?id=169&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/64275801657630.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20181025/7521729121819.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (65, '刘备', '仁德义枪', '战士', '仁德义枪|万事如意|纽约教父|汉昭烈帝', '//pvp.qq.com/act/a20180905herostory/index.html?id=170&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/980091411957883.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/16495784782816.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (66, '张飞', '禁血狂兽', '辅助/坦克', '禁血狂兽|五福同心|乱世虎臣', '//pvp.qq.com/act/a20180905herostory/index.html?id=171&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/184661526306200.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/941221097359270.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (67, '李元芳', '王都密探', '射手', '王都密探|特种部队|黑猫爱糖果|逐浪之夏', '//pvp.qq.com/act/a20180905herostory/index.html?id=173&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/536601401910051.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20181025/289431194455887.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (68, '虞姬', '森之风灵', '射手', '森之风灵|加勒比小姐|霸王别姬|凯尔特女王', '//pvp.qq.com/act/a20180905herostory/index.html?id=174&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/85572974862749.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180327/75023658143716.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (69, '钟馗', '虚灵城判', '法师/战士', '虚灵城判|地府判官', '//pvp.qq.com/act/a20180905herostory/index.html?id=175&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/203361241905570.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180122/79835640494001.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (70, '成吉思汗', '苍狼末裔', '射手', '苍狼末裔|维京掠夺者', '//pvp.qq.com/act/a20180905herostory/index.html?id=177&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/669879518974.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160918/21931014171659.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (71, '杨戬', '根源之目', '战士', '根源之目|埃及法老|永曜之星', '//pvp.qq.com/act/a20180905herostory/index.html?id=178&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/365511150355588.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20161008/81211237899931.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (72, '雅典娜', '圣域余晖', '战士', '圣域余晖|战争女神|冰冠公主|神奇女侠', '//pvp.qq.com/act/a20180905herostory/index.html?id=183&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/44483332637077.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190524/64614584030878.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (73, '蔡文姬', '天籁弦音', '辅助', '天籁弦音|蔷薇王座|舞动绿茵|奇迹圣诞', '//pvp.qq.com/act/a20180905herostory/index.html?id=184&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/9456290393768.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20160726/8277177112204.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (74, '太乙真人', '炼金大师', '辅助/坦克', '炼金大师|圆桌骑士|饕餮|华丽摇滚', '//pvp.qq.com/act/a20180905herostory/index.html?id=186&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/524241070493059.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20161124/29648640143170.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (75, '哪吒', '桀骜炎枪', '战士', '桀骜炎枪|三太子|逐梦之翼', '//pvp.qq.com/act/a20180905herostory/index.html?id=180&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/652021297028542.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20170104/952661342083635.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (76, '诸葛亮', '绝代智谋', '法师', '绝代智谋|星航指挥官|黄金分割率|武陵仙君|掌控之力', '//pvp.qq.com/act/a20180905herostory/index.html?id=190&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/29138566540861.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20170118/48646263962066.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (77, '黄忠', '燃魂重炮', '射手', '燃魂重炮|芝加哥教父', '//pvp.qq.com/act/a20180905herostory/index.html?id=192&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/85062883647203.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20170203/81719401485448.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (78, '大乔', '沧海之曜', '辅助', '沧海之曜|伊势巫女|守护之力|猫狗日记', '//pvp.qq.com/act/a20180905herostory/index.html?id=191&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/39697765755935.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20170217/62422276203551.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (79, '东皇太一', '噬灭日蚀', '辅助/坦克', '噬灭日蚀|东海龙王|逐梦之光', '//pvp.qq.com/act/a20180905herostory/index.html?id=187&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/33388656891546.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20170317/94767842334793.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (80, '干将莫邪', '淬命双剑', '法师', '淬命双剑|第七人偶|冰霜恋舞曲', '//pvp.qq.com/act/a20180905herostory/index.html?id=182&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/42817207621092.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20170524/87618567096649.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (81, '鬼谷子', '万物有灵', '辅助', '万物有灵|阿摩司公爵|幻乐之宴', '//pvp.qq.com/act/a20180905herostory/index.html?id=189&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/88527151660191.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20170621/886741128494673.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (82, '铠', '破灭刃锋', '战士/坦克', '破灭刃锋|龙域领主|曙光守护者|青龙志', '//pvp.qq.com/act/a20180905herostory/index.html?id=193&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/40660475542197.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20170703/82350987230843.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (83, '百里守约', '静谧之眼', '射手', '静谧之眼|绝影神枪|特工魅影|朱雀志', '//pvp.qq.com/act/a20180905herostory/index.html?id=196&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/973981525713211.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20170728/457611237008978.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (84, '百里玄策', '嚣狂之镰', '刺客', '嚣狂之镰|威尼斯狂欢|白虎志', '//pvp.qq.com/act/a20180905herostory/index.html?id=195&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/70144136701374.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20170817/84625581125048.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (85, '苏烈', '不屈铁壁', '坦克/战士', '不屈铁壁|爱与和平|坚韧之力|玄武志', '//pvp.qq.com/act/a20180905herostory/index.html?id=194&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/75102223449716.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20170921/73767796416726.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (86, '梦奇', '入梦之灵', '战士/坦克', '入梦之灵|美梦成真|胖达荣荣', '//pvp.qq.com/act/a20180905herostory/index.html?id=198&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20210510/88228768602449.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20210510/23016587216986.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (87, '女娲', '至高创世', '法师', '至高创世|尼罗河女神', '//pvp.qq.com/act/a20180905herostory/index.html?id=179&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/957611093104192.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20171116/969111664137.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (88, '明世隐', '灵魂劫卜', '辅助', '灵魂劫卜|占星术士|虹云星官', '//pvp.qq.com/act/a20180905herostory/index.html?id=501&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/950592351878.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20171204/28305587201309.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (89, '公孙离', '幻舞玲珑', '射手', '幻舞玲珑|花间舞|蜜橘之夏', '//pvp.qq.com/act/a20180905herostory/index.html?id=199&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/85961165268981.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180117/403241369215383.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (90, '杨玉环', '霓裳风华', '法师/辅助', '风华霓裳|霓裳曲|遇见飞天', '//pvp.qq.com/act/a20180905herostory/index.html?id=176&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/316771484611139.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180205/26781833129059.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (91, '裴擒虎', '六合虎拳', '刺客/战士', '六合虎拳|街头霸王|梅西', '//pvp.qq.com/act/a20180905herostory/index.html?id=502&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/69916960929378.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180208/24328465009145.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (92, '弈星', '天元之弈', '法师', '天元之弈|踏雪寻梅', '//pvp.qq.com/act/a20180905herostory/index.html?id=197&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20210922/84992915823949.png', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20210922/47732222929767.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (93, '狂铁', '战车意志', '战士', '战车意志|命运角斗场|御狮', '//pvp.qq.com/act/a20180905herostory/index.html?id=503&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/7239917087550.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180412/546911293826154.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (94, '米莱狄', '筑城者', '法师', '筑城者|精准探案法|御霄', '//pvp.qq.com/act/a20180905herostory/index.html?id=504&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/46616375519675.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180510/96802286473688.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (95, '元歌', '无间傀儡', '刺客', '无间傀儡|午夜歌剧院', '//pvp.qq.com/act/a20180905herostory/index.html?id=125&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/227131284204645.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180628/795971480753540.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (96, '孙策', '光明之海', '战士/坦克', '光明之海|海之征途|猫狗日记', '//pvp.qq.com/act/a20180905herostory/index.html?id=510&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/67846590935414.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180717/10339910137309.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (97, '司马懿', '寂灭之心', '刺客/法师', '寂灭之心|魇语军师', '//pvp.qq.com/act/a20180905herostory/index.html?id=137&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/332921188655301.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180816/813571069462033.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (98, '盾山', '无尽之盾', '辅助/坦克', '无尽之盾|极冰防御线', '//pvp.qq.com/act/a20180905herostory/index.html?id=509&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/953261427583808.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180904/71811613439812.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (99, '伽罗', '破魔之箭', '射手', '破魔之箭|花见巫女', '//pvp.qq.com/act/a20180905herostory/index.html?id=508&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/15595309331581.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20180921/75205278535459.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (100, '沈梦溪', '爆弹怪猫', '法师', '爆弹怪猫|棒球奇才', '//pvp.qq.com/act/a20180905herostory/index.html?id=312&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/293661177557011.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20181019/13265340386756.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (101, '李信', '谋世之战', '战士', '谋世之战|灼热之刃', '//pvp.qq.com/act/a20180905herostory/index.html?id=507&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/45330314537943.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20181120/7804990460330.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (102, '上官婉儿', '惊鸿之笔', '法师', '惊鸿之笔|修竹墨客', '//pvp.qq.com/act/a20180905herostory/index.html?id=513&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/218171149641279.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20181211/715691338489128.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (103, '嫦娥', '寒月公主', '法师/坦克', '寒月公主|露花倒影', '//pvp.qq.com/act/a20180905herostory/index.html?id=515&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/353911202229544.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190111/868981192916415.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (104, '猪八戒', '无忧猛士', '坦克', '无忧猛士|年年有余', '//pvp.qq.com/act/a20180905herostory/index.html?id=511&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/99063960055644.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190121/59935186584184.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (105, '盘古', '破晓之神', '战士', '破晓之神', 'https://pvp.qq.com/act/a20180905herostory/index.html?id=529&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/19615858476334.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190218/16716956397489.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (106, '瑶', '鹿灵守心', '辅助', '森', 'https://pvp.qq.com/act/a20180905herostory/index.html?id=505&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/757821175652297.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190415/22946736869045.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (107, '云中君', '流云之翼', '刺客/战士', '荷鲁斯之眼', 'https://pvp.qq.com/act/a20180905herostory/index.html?id=506&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/86214230515643.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190510/38160378200548.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (108, '曜', '星辰之子', '战士', '归虚梦演', 'https://pvp.qq.com/act/a20180905herostory/index.html?id=522&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/770901264838612.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190625/86727196039895.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (109, '马超', '冷晖之枪', '战士', '冷晖之枪|幸存者|神威', 'https://pvp.qq.com/act/a20180905herostory/index.html?id=518&ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/33883177785525.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190813/47880503928005.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (110, '西施', '幻纱之灵', '法师', '幻纱之灵|归虚梦演', 'https://pvp.qq.com/story201904/index.html#/heroDetail/index/523?ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191010/87864951621394.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20190920/52701914999686.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (111, '鲁班大师', '神匠', '辅助', '神匠|归虚梦演', 'https://pvp.qq.com/story201904/index.html#/heroDetail/index/525?ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191126/72226651341391.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20191126/57064767888562.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (112, '蒙犽', '烈炮小子', '射手', '烈炮小子|归虚梦演', 'https://pvp.qq.com/story201904/index.html#/heroDetail/index/524?ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20200109/645021221580209.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20200109/769101262329107.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (113, '镜', '破镜之刃', '刺客', '破镜之刃|冰刃幻境', 'https://pvp.qq.com/story201904/index.html#/heroDetail/index/531?ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20200327/25718162647590.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20200327/396541250647794.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (114, '蒙恬', '秩序统将', '战士/坦克', '秩序统将|秩序猎龙将', 'https://pvp.qq.com/story201904/index.html#/heroDetail/index/527?ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20200601/79145982836583.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20200601/97479618556133.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (115, '阿古朵', '山林之子', '坦克/辅助', '山林之子', 'https://pvp.qq.com/story201904/index.html#/heroDetail/index/533?ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20200730/908422776017.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20200730/2465499023977.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (116, '夏洛特', '玫瑰剑士', '战士', '玫瑰剑士', 'https://pvp.qq.com/story201904/index.html#/heroDetail/index/536?ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20200921/27859854994324.png', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20200921/438831094577151.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (117, '澜', '鲨之猎刃', '刺客', '鲨之猎刃|孤猎', 'https://pvp.qq.com/story201904/index.html#/heroDetail/index/528?ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20201208/35161952266060.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20201208/644721207778332.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (118, '司空震', '雷霆之王', '战士/法师', '雷霆之王|启蛰', 'https://pvp.qq.com/story201904/index.html#/heroDetail/index/537?ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20210112/85473239526448.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20210112/98246362641488.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (119, '艾琳', '精灵之舞', '射手', '精灵之舞|女武神', 'https://pvp.qq.com/story201904/index.html#/heroDetail/index/155?ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20210407/384301448271504.png', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20210407/571741466946835.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (120, '云缨', '燎原之心', '战士', '燎原之心|赤焰之缨', 'https://pvp.qq.com/story201904/index.html#/heroDetail/index/538?ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20210621/45838846827439.jpg', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20210621/23553953591021.jpg', '2022-10-16 14:07:43', '2022-10-16 14:07:43');
INSERT INTO `hero_list` VALUES (121, '金蝉', '渡世行者', '法师', '渡世行者|前尘', 'https://pvp.qq.com/story201904/index.html#/heroDetail/index/540?ADTAG=pvp.storyweb', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20211116/10927593674507.png', '//ossweb-img.qq.com/upload/webplat/info/yxzj/20211115/730421262848940.png', '2022-10-16 14:07:43', '2022-10-16 14:07:43');

-- ----------------------------
-- Table structure for province
-- ----------------------------
DROP TABLE IF EXISTS `province`;
CREATE TABLE `province`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `postCode` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 348 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of province
-- ----------------------------
INSERT INTO `province` VALUES (1, '北京市', '市辖区', '110100');
INSERT INTO `province` VALUES (2, '天津市', '市辖区', '120100');
INSERT INTO `province` VALUES (3, '河北省', '石家庄市', '130100');
INSERT INTO `province` VALUES (4, '河北省', '唐山市', '130200');
INSERT INTO `province` VALUES (5, '河北省', '邯郸市', '130400');
INSERT INTO `province` VALUES (6, '河北省', '秦皇岛市', '130300');
INSERT INTO `province` VALUES (7, '河北省', '保定市', '130600');
INSERT INTO `province` VALUES (8, '河北省', '邢台市', '130500');
INSERT INTO `province` VALUES (9, '河北省', '张家口市', '130700');
INSERT INTO `province` VALUES (10, '河北省', '承德市', '130800');
INSERT INTO `province` VALUES (11, '河北省', '沧州市', '130900');
INSERT INTO `province` VALUES (12, '河北省', '廊坊市', '131000');
INSERT INTO `province` VALUES (13, '河北省', '衡水市', '131100');
INSERT INTO `province` VALUES (14, '河北省', '省直辖县级行政区划', '139000');
INSERT INTO `province` VALUES (15, '山西省', '太原市', '140100');
INSERT INTO `province` VALUES (16, '山西省', '阳泉市', '140300');
INSERT INTO `province` VALUES (17, '山西省', '大同市', '140200');
INSERT INTO `province` VALUES (18, '山西省', '朔州市', '140600');
INSERT INTO `province` VALUES (19, '山西省', '长治市', '140400');
INSERT INTO `province` VALUES (20, '山西省', '晋城市', '140500');
INSERT INTO `province` VALUES (21, '山西省', '晋中市', '140700');
INSERT INTO `province` VALUES (22, '山西省', '运城市', '140800');
INSERT INTO `province` VALUES (23, '山西省', '忻州市', '140900');
INSERT INTO `province` VALUES (24, '山西省', '吕梁市', '141100');
INSERT INTO `province` VALUES (25, '山西省', '临汾市', '141000');
INSERT INTO `province` VALUES (26, '内蒙古自治区', '呼和浩特市', '150100');
INSERT INTO `province` VALUES (27, '内蒙古自治区', '包头市', '150200');
INSERT INTO `province` VALUES (28, '内蒙古自治区', '赤峰市', '150400');
INSERT INTO `province` VALUES (29, '内蒙古自治区', '通辽市', '150500');
INSERT INTO `province` VALUES (30, '内蒙古自治区', '乌海市', '150300');
INSERT INTO `province` VALUES (31, '内蒙古自治区', '鄂尔多斯市', '150600');
INSERT INTO `province` VALUES (32, '内蒙古自治区', '呼伦贝尔市', '150700');
INSERT INTO `province` VALUES (33, '内蒙古自治区', '巴彦淖尔市', '150800');
INSERT INTO `province` VALUES (34, '内蒙古自治区', '乌兰察布市', '150900');
INSERT INTO `province` VALUES (35, '内蒙古自治区', '锡林郭勒盟', '152500');
INSERT INTO `province` VALUES (36, '内蒙古自治区', '阿拉善盟', '152900');
INSERT INTO `province` VALUES (37, '辽宁省', '沈阳市', '210100');
INSERT INTO `province` VALUES (38, '内蒙古自治区', '兴安盟', '152200');
INSERT INTO `province` VALUES (39, '辽宁省', '抚顺市', '210400');
INSERT INTO `province` VALUES (40, '辽宁省', '鞍山市', '210300');
INSERT INTO `province` VALUES (41, '辽宁省', '本溪市', '210500');
INSERT INTO `province` VALUES (42, '辽宁省', '大连市', '210200');
INSERT INTO `province` VALUES (43, '辽宁省', '丹东市', '210600');
INSERT INTO `province` VALUES (44, '辽宁省', '锦州市', '210700');
INSERT INTO `province` VALUES (45, '辽宁省', '阜新市', '210900');
INSERT INTO `province` VALUES (46, '辽宁省', '辽阳市', '211000');
INSERT INTO `province` VALUES (47, '辽宁省', '营口市', '210800');
INSERT INTO `province` VALUES (48, '辽宁省', '盘锦市', '211100');
INSERT INTO `province` VALUES (49, '辽宁省', '朝阳市', '211300');
INSERT INTO `province` VALUES (50, '辽宁省', '铁岭市', '211200');
INSERT INTO `province` VALUES (51, '吉林省', '长春市', '220100');
INSERT INTO `province` VALUES (52, '辽宁省', '葫芦岛市', '211400');
INSERT INTO `province` VALUES (53, '吉林省', '四平市', '220300');
INSERT INTO `province` VALUES (54, '吉林省', '辽源市', '220400');
INSERT INTO `province` VALUES (55, '吉林省', '吉林市', '220200');
INSERT INTO `province` VALUES (56, '吉林省', '通化市', '220500');
INSERT INTO `province` VALUES (57, '吉林省', '白山市', '220600');
INSERT INTO `province` VALUES (58, '吉林省', '白城市', '220800');
INSERT INTO `province` VALUES (59, '吉林省', '延边朝鲜族自治州', '222400');
INSERT INTO `province` VALUES (60, '黑龙江省', '哈尔滨市', '230100');
INSERT INTO `province` VALUES (61, '吉林省', '松原市', '220700');
INSERT INTO `province` VALUES (62, '黑龙江省', '齐齐哈尔市', '230200');
INSERT INTO `province` VALUES (63, '黑龙江省', '鸡西市', '230300');
INSERT INTO `province` VALUES (64, '黑龙江省', '鹤岗市', '230400');
INSERT INTO `province` VALUES (65, '黑龙江省', '大庆市', '230600');
INSERT INTO `province` VALUES (66, '黑龙江省', '双鸭山市', '230500');
INSERT INTO `province` VALUES (67, '黑龙江省', '伊春市', '230700');
INSERT INTO `province` VALUES (68, '黑龙江省', '佳木斯市', '230800');
INSERT INTO `province` VALUES (69, '黑龙江省', '七台河市', '230900');
INSERT INTO `province` VALUES (70, '黑龙江省', '牡丹江市', '231000');
INSERT INTO `province` VALUES (71, '黑龙江省', '绥化市', '231200');
INSERT INTO `province` VALUES (72, '黑龙江省', '黑河市', '231100');
INSERT INTO `province` VALUES (73, '黑龙江省', '大兴安岭地区', '232700');
INSERT INTO `province` VALUES (74, '江苏省', '南京市', '320100');
INSERT INTO `province` VALUES (75, '上海市', '市辖区', '310100');
INSERT INTO `province` VALUES (76, '江苏省', '无锡市', '320200');
INSERT INTO `province` VALUES (77, '江苏省', '常州市', '320400');
INSERT INTO `province` VALUES (78, '江苏省', '苏州市', '320500');
INSERT INTO `province` VALUES (79, '江苏省', '徐州市', '320300');
INSERT INTO `province` VALUES (80, '江苏省', '连云港市', '320700');
INSERT INTO `province` VALUES (81, '江苏省', '淮安市', '320800');
INSERT INTO `province` VALUES (82, '江苏省', '南通市', '320600');
INSERT INTO `province` VALUES (83, '江苏省', '扬州市', '321000');
INSERT INTO `province` VALUES (84, '江苏省', '盐城市', '320900');
INSERT INTO `province` VALUES (85, '江苏省', '镇江市', '321100');
INSERT INTO `province` VALUES (86, '江苏省', '泰州市', '321200');
INSERT INTO `province` VALUES (87, '浙江省', '杭州市', '330100');
INSERT INTO `province` VALUES (88, '浙江省', '宁波市', '330200');
INSERT INTO `province` VALUES (89, '江苏省', '宿迁市', '321300');
INSERT INTO `province` VALUES (90, '浙江省', '嘉兴市', '330400');
INSERT INTO `province` VALUES (91, '浙江省', '温州市', '330300');
INSERT INTO `province` VALUES (92, '浙江省', '湖州市', '330500');
INSERT INTO `province` VALUES (93, '浙江省', '金华市', '330700');
INSERT INTO `province` VALUES (94, '浙江省', '绍兴市', '330600');
INSERT INTO `province` VALUES (95, '浙江省', '衢州市', '330800');
INSERT INTO `province` VALUES (96, '浙江省', '台州市', '331000');
INSERT INTO `province` VALUES (97, '浙江省', '丽水市', '331100');
INSERT INTO `province` VALUES (98, '浙江省', '舟山市', '330900');
INSERT INTO `province` VALUES (99, '安徽省', '合肥市', '340100');
INSERT INTO `province` VALUES (100, '安徽省', '芜湖市', '340200');
INSERT INTO `province` VALUES (101, '安徽省', '蚌埠市', '340300');
INSERT INTO `province` VALUES (102, '安徽省', '淮南市', '340400');
INSERT INTO `province` VALUES (103, '安徽省', '马鞍山市', '340500');
INSERT INTO `province` VALUES (104, '安徽省', '淮北市', '340600');
INSERT INTO `province` VALUES (105, '安徽省', '铜陵市', '340700');
INSERT INTO `province` VALUES (106, '安徽省', '安庆市', '340800');
INSERT INTO `province` VALUES (107, '安徽省', '黄山市', '341000');
INSERT INTO `province` VALUES (108, '安徽省', '滁州市', '341100');
INSERT INTO `province` VALUES (109, '安徽省', '阜阳市', '341200');
INSERT INTO `province` VALUES (110, '安徽省', '六安市', '341500');
INSERT INTO `province` VALUES (111, '安徽省', '亳州市', '341600');
INSERT INTO `province` VALUES (112, '安徽省', '宿州市', '341300');
INSERT INTO `province` VALUES (113, '安徽省', '宣城市', '341800');
INSERT INTO `province` VALUES (114, '安徽省', '池州市', '341700');
INSERT INTO `province` VALUES (115, '福建省', '福州市', '350100');
INSERT INTO `province` VALUES (116, '福建省', '厦门市', '350200');
INSERT INTO `province` VALUES (117, '福建省', '莆田市', '350300');
INSERT INTO `province` VALUES (118, '福建省', '三明市', '350400');
INSERT INTO `province` VALUES (119, '福建省', '泉州市', '350500');
INSERT INTO `province` VALUES (120, '福建省', '漳州市', '350600');
INSERT INTO `province` VALUES (121, '福建省', '南平市', '350700');
INSERT INTO `province` VALUES (122, '福建省', '龙岩市', '350800');
INSERT INTO `province` VALUES (123, '江西省', '南昌市', '360100');
INSERT INTO `province` VALUES (124, '江西省', '景德镇市', '360200');
INSERT INTO `province` VALUES (125, '江西省', '萍乡市', '360300');
INSERT INTO `province` VALUES (126, '福建省', '宁德市', '350900');
INSERT INTO `province` VALUES (127, '江西省', '九江市', '360400');
INSERT INTO `province` VALUES (128, '江西省', '新余市', '360500');
INSERT INTO `province` VALUES (129, '江西省', '鹰潭市', '360600');
INSERT INTO `province` VALUES (130, '江西省', '赣州市', '360700');
INSERT INTO `province` VALUES (131, '江西省', '吉安市', '360800');
INSERT INTO `province` VALUES (132, '江西省', '宜春市', '360900');
INSERT INTO `province` VALUES (133, '江西省', '抚州市', '361000');
INSERT INTO `province` VALUES (134, '江西省', '上饶市', '361100');
INSERT INTO `province` VALUES (135, '山东省', '济南市', '370100');
INSERT INTO `province` VALUES (136, '山东省', '淄博市', '370300');
INSERT INTO `province` VALUES (137, '山东省', '东营市', '370500');
INSERT INTO `province` VALUES (138, '山东省', '枣庄市', '370400');
INSERT INTO `province` VALUES (139, '山东省', '烟台市', '370600');
INSERT INTO `province` VALUES (140, '山东省', '青岛市', '370200');
INSERT INTO `province` VALUES (141, '山东省', '潍坊市', '370700');
INSERT INTO `province` VALUES (142, '山东省', '济宁市', '370800');
INSERT INTO `province` VALUES (143, '山东省', '威海市', '371000');
INSERT INTO `province` VALUES (144, '山东省', '泰安市', '370900');
INSERT INTO `province` VALUES (145, '山东省', '日照市', '371100');
INSERT INTO `province` VALUES (146, '山东省', '莱芜市', '371200');
INSERT INTO `province` VALUES (147, '山东省', '德州市', '371400');
INSERT INTO `province` VALUES (148, '山东省', '聊城市', '371500');
INSERT INTO `province` VALUES (149, '山东省', '临沂市', '371300');
INSERT INTO `province` VALUES (150, '山东省', '滨州市', '371600');
INSERT INTO `province` VALUES (151, '山东省', '菏泽市', '371700');
INSERT INTO `province` VALUES (152, '河南省', '郑州市', '410100');
INSERT INTO `province` VALUES (153, '河南省', '开封市', '410200');
INSERT INTO `province` VALUES (154, '河南省', '平顶山市', '410400');
INSERT INTO `province` VALUES (155, '河南省', '安阳市', '410500');
INSERT INTO `province` VALUES (156, '河南省', '鹤壁市', '410600');
INSERT INTO `province` VALUES (157, '河南省', '洛阳市', '410300');
INSERT INTO `province` VALUES (158, '河南省', '新乡市', '410700');
INSERT INTO `province` VALUES (159, '河南省', '焦作市', '410800');
INSERT INTO `province` VALUES (160, '河南省', '濮阳市', '410900');
INSERT INTO `province` VALUES (161, '河南省', '许昌市', '411000');
INSERT INTO `province` VALUES (162, '河南省', '漯河市', '411100');
INSERT INTO `province` VALUES (163, '河南省', '三门峡市', '411200');
INSERT INTO `province` VALUES (164, '河南省', '商丘市', '411400');
INSERT INTO `province` VALUES (165, '河南省', '南阳市', '411300');
INSERT INTO `province` VALUES (166, '河南省', '信阳市', '411500');
INSERT INTO `province` VALUES (167, '河南省', '周口市', '411600');
INSERT INTO `province` VALUES (168, '河南省', '驻马店市', '411700');
INSERT INTO `province` VALUES (169, '河南省', '省直辖县级行政区划', '419000');
INSERT INTO `province` VALUES (170, '湖北省', '武汉市', '420100');
INSERT INTO `province` VALUES (171, '湖北省', '十堰市', '420300');
INSERT INTO `province` VALUES (172, '湖北省', '黄石市', '420200');
INSERT INTO `province` VALUES (173, '湖北省', '宜昌市', '420500');
INSERT INTO `province` VALUES (174, '湖北省', '襄阳市', '420600');
INSERT INTO `province` VALUES (175, '湖北省', '荆门市', '420800');
INSERT INTO `province` VALUES (176, '湖北省', '鄂州市', '420700');
INSERT INTO `province` VALUES (177, '湖北省', '荆州市', '421000');
INSERT INTO `province` VALUES (178, '湖北省', '孝感市', '420900');
INSERT INTO `province` VALUES (179, '湖北省', '黄冈市', '421100');
INSERT INTO `province` VALUES (180, '湖北省', '咸宁市', '421200');
INSERT INTO `province` VALUES (181, '湖北省', '随州市', '421300');
INSERT INTO `province` VALUES (182, '湖北省', '恩施土家族苗族自治州', '422800');
INSERT INTO `province` VALUES (183, '湖南省', '长沙市', '430100');
INSERT INTO `province` VALUES (184, '湖北省', '省直辖县级行政区划', '429000');
INSERT INTO `province` VALUES (185, '湖南省', '株洲市', '430200');
INSERT INTO `province` VALUES (186, '湖南省', '衡阳市', '430400');
INSERT INTO `province` VALUES (187, '湖南省', '邵阳市', '430500');
INSERT INTO `province` VALUES (188, '湖南省', '湘潭市', '430300');
INSERT INTO `province` VALUES (189, '湖南省', '岳阳市', '430600');
INSERT INTO `province` VALUES (190, '湖南省', '常德市', '430700');
INSERT INTO `province` VALUES (191, '湖南省', '张家界市', '430800');
INSERT INTO `province` VALUES (192, '湖南省', '郴州市', '431000');
INSERT INTO `province` VALUES (193, '湖南省', '永州市', '431100');
INSERT INTO `province` VALUES (194, '湖南省', '益阳市', '430900');
INSERT INTO `province` VALUES (195, '湖南省', '怀化市', '431200');
INSERT INTO `province` VALUES (196, '湖南省', '娄底市', '431300');
INSERT INTO `province` VALUES (197, '湖南省', '湘西土家族苗族自治州', '433100');
INSERT INTO `province` VALUES (198, '广东省', '韶关市', '440200');
INSERT INTO `province` VALUES (199, '广东省', '广州市', '440100');
INSERT INTO `province` VALUES (200, '广东省', '珠海市', '440400');
INSERT INTO `province` VALUES (201, '广东省', '深圳市', '440300');
INSERT INTO `province` VALUES (202, '广东省', '佛山市', '440600');
INSERT INTO `province` VALUES (203, '广东省', '江门市', '440700');
INSERT INTO `province` VALUES (204, '广东省', '汕头市', '440500');
INSERT INTO `province` VALUES (205, '广东省', '湛江市', '440800');
INSERT INTO `province` VALUES (206, '广东省', '茂名市', '440900');
INSERT INTO `province` VALUES (207, '广东省', '肇庆市', '441200');
INSERT INTO `province` VALUES (208, '广东省', '惠州市', '441300');
INSERT INTO `province` VALUES (209, '广东省', '梅州市', '441400');
INSERT INTO `province` VALUES (210, '广东省', '汕尾市', '441500');
INSERT INTO `province` VALUES (211, '广东省', '河源市', '441600');
INSERT INTO `province` VALUES (212, '广东省', '阳江市', '441700');
INSERT INTO `province` VALUES (213, '广东省', '清远市', '441800');
INSERT INTO `province` VALUES (214, '广东省', '东莞市', '441900');
INSERT INTO `province` VALUES (215, '广东省', '中山市', '442000');
INSERT INTO `province` VALUES (216, '广东省', '潮州市', '445100');
INSERT INTO `province` VALUES (217, '广东省', '揭阳市', '445200');
INSERT INTO `province` VALUES (218, '广东省', '云浮市', '445300');
INSERT INTO `province` VALUES (219, '广西壮族自治区', '南宁市', '450100');
INSERT INTO `province` VALUES (220, '广西壮族自治区', '柳州市', '450200');
INSERT INTO `province` VALUES (221, '广西壮族自治区', '梧州市', '450400');
INSERT INTO `province` VALUES (222, '广西壮族自治区', '北海市', '450500');
INSERT INTO `province` VALUES (223, '广西壮族自治区', '桂林市', '450300');
INSERT INTO `province` VALUES (224, '广西壮族自治区', '防城港市', '450600');
INSERT INTO `province` VALUES (225, '广西壮族自治区', '贵港市', '450800');
INSERT INTO `province` VALUES (226, '广西壮族自治区', '玉林市', '450900');
INSERT INTO `province` VALUES (227, '广西壮族自治区', '钦州市', '450700');
INSERT INTO `province` VALUES (228, '广西壮族自治区', '百色市', '451000');
INSERT INTO `province` VALUES (229, '广西壮族自治区', '河池市', '451200');
INSERT INTO `province` VALUES (230, '广西壮族自治区', '贺州市', '451100');
INSERT INTO `province` VALUES (231, '海南省', '海口市', '460100');
INSERT INTO `province` VALUES (232, '广西壮族自治区', '来宾市', '451300');
INSERT INTO `province` VALUES (233, '海南省', '三亚市', '460200');
INSERT INTO `province` VALUES (234, '广西壮族自治区', '崇左市', '451400');
INSERT INTO `province` VALUES (235, '海南省', '三沙市', '460300');
INSERT INTO `province` VALUES (236, '海南省', '省直辖县级行政区划', '469000');
INSERT INTO `province` VALUES (237, '重庆市', '市辖区', '500100');
INSERT INTO `province` VALUES (238, '重庆市', '县', '500200');
INSERT INTO `province` VALUES (239, '海南省', '儋州市', '460400');
INSERT INTO `province` VALUES (240, '四川省', '自贡市', '510300');
INSERT INTO `province` VALUES (241, '四川省', '成都市', '510100');
INSERT INTO `province` VALUES (242, '四川省', '攀枝花市', '510400');
INSERT INTO `province` VALUES (243, '四川省', '德阳市', '510600');
INSERT INTO `province` VALUES (244, '四川省', '泸州市', '510500');
INSERT INTO `province` VALUES (245, '四川省', '绵阳市', '510700');
INSERT INTO `province` VALUES (246, '四川省', '广元市', '510800');
INSERT INTO `province` VALUES (247, '四川省', '遂宁市', '510900');
INSERT INTO `province` VALUES (248, '四川省', '乐山市', '511100');
INSERT INTO `province` VALUES (249, '四川省', '内江市', '511000');
INSERT INTO `province` VALUES (250, '四川省', '南充市', '511300');
INSERT INTO `province` VALUES (251, '四川省', '眉山市', '511400');
INSERT INTO `province` VALUES (252, '四川省', '广安市', '511600');
INSERT INTO `province` VALUES (253, '四川省', '达州市', '511700');
INSERT INTO `province` VALUES (254, '四川省', '宜宾市', '511500');
INSERT INTO `province` VALUES (255, '四川省', '巴中市', '511900');
INSERT INTO `province` VALUES (256, '四川省', '雅安市', '511800');
INSERT INTO `province` VALUES (257, '四川省', '阿坝藏族羌族自治州', '513200');
INSERT INTO `province` VALUES (258, '四川省', '甘孜藏族自治州', '513300');
INSERT INTO `province` VALUES (259, '四川省', '资阳市', '512000');
INSERT INTO `province` VALUES (260, '四川省', '凉山彝族自治州', '513400');
INSERT INTO `province` VALUES (261, '贵州省', '六盘水市', '520200');
INSERT INTO `province` VALUES (262, '贵州省', '遵义市', '520300');
INSERT INTO `province` VALUES (263, '贵州省', '贵阳市', '520100');
INSERT INTO `province` VALUES (264, '贵州省', '毕节市', '520500');
INSERT INTO `province` VALUES (265, '贵州省', '铜仁市', '520600');
INSERT INTO `province` VALUES (266, '贵州省', '安顺市', '520400');
INSERT INTO `province` VALUES (267, '贵州省', '黔东南苗族侗族自治州', '522600');
INSERT INTO `province` VALUES (268, '贵州省', '黔西南布依族苗族自治州', '522300');
INSERT INTO `province` VALUES (269, '贵州省', '黔南布依族苗族自治州', '522700');
INSERT INTO `province` VALUES (270, '云南省', '昆明市', '530100');
INSERT INTO `province` VALUES (271, '云南省', '玉溪市', '530400');
INSERT INTO `province` VALUES (272, '云南省', '曲靖市', '530300');
INSERT INTO `province` VALUES (273, '云南省', '保山市', '530500');
INSERT INTO `province` VALUES (274, '云南省', '昭通市', '530600');
INSERT INTO `province` VALUES (275, '云南省', '临沧市', '530900');
INSERT INTO `province` VALUES (276, '云南省', '丽江市', '530700');
INSERT INTO `province` VALUES (277, '云南省', '楚雄彝族自治州', '532300');
INSERT INTO `province` VALUES (278, '云南省', '红河哈尼族彝族自治州', '532500');
INSERT INTO `province` VALUES (279, '云南省', '文山壮族苗族自治州', '532600');
INSERT INTO `province` VALUES (280, '云南省', '西双版纳傣族自治州', '532800');
INSERT INTO `province` VALUES (281, '云南省', '普洱市', '530800');
INSERT INTO `province` VALUES (282, '云南省', '大理白族自治州', '532900');
INSERT INTO `province` VALUES (283, '云南省', '德宏傣族景颇族自治州', '533100');
INSERT INTO `province` VALUES (284, '云南省', '怒江傈僳族自治州', '533300');
INSERT INTO `province` VALUES (285, '西藏自治区', '拉萨市', '540100');
INSERT INTO `province` VALUES (286, '西藏自治区', '日喀则市', '540200');
INSERT INTO `province` VALUES (287, '云南省', '迪庆藏族自治州', '533400');
INSERT INTO `province` VALUES (288, '西藏自治区', '昌都市', '540300');
INSERT INTO `province` VALUES (289, '西藏自治区', '山南市', '540500');
INSERT INTO `province` VALUES (290, '西藏自治区', '那曲地区', '542400');
INSERT INTO `province` VALUES (291, '西藏自治区', '阿里地区', '542500');
INSERT INTO `province` VALUES (292, '西藏自治区', '林芝市', '540400');
INSERT INTO `province` VALUES (293, '陕西省', '西安市', '610100');
INSERT INTO `province` VALUES (294, '陕西省', '铜川市', '610200');
INSERT INTO `province` VALUES (295, '陕西省', '宝鸡市', '610300');
INSERT INTO `province` VALUES (296, '陕西省', '咸阳市', '610400');
INSERT INTO `province` VALUES (297, '陕西省', '汉中市', '610700');
INSERT INTO `province` VALUES (298, '陕西省', '渭南市', '610500');
INSERT INTO `province` VALUES (299, '陕西省', '延安市', '610600');
INSERT INTO `province` VALUES (300, '陕西省', '安康市', '610900');
INSERT INTO `province` VALUES (301, '陕西省', '榆林市', '610800');
INSERT INTO `province` VALUES (302, '甘肃省', '嘉峪关市', '620200');
INSERT INTO `province` VALUES (303, '甘肃省', '金昌市', '620300');
INSERT INTO `province` VALUES (304, '甘肃省', '兰州市', '620100');
INSERT INTO `province` VALUES (305, '陕西省', '商洛市', '611000');
INSERT INTO `province` VALUES (306, '甘肃省', '白银市', '620400');
INSERT INTO `province` VALUES (307, '甘肃省', '天水市', '620500');
INSERT INTO `province` VALUES (308, '甘肃省', '武威市', '620600');
INSERT INTO `province` VALUES (309, '甘肃省', '平凉市', '620800');
INSERT INTO `province` VALUES (310, '甘肃省', '酒泉市', '620900');
INSERT INTO `province` VALUES (311, '甘肃省', '张掖市', '620700');
INSERT INTO `province` VALUES (312, '甘肃省', '定西市', '621100');
INSERT INTO `province` VALUES (313, '甘肃省', '陇南市', '621200');
INSERT INTO `province` VALUES (314, '甘肃省', '庆阳市', '621000');
INSERT INTO `province` VALUES (315, '甘肃省', '临夏回族自治州', '622900');
INSERT INTO `province` VALUES (316, '青海省', '西宁市', '630100');
INSERT INTO `province` VALUES (317, '甘肃省', '甘南藏族自治州', '623000');
INSERT INTO `province` VALUES (318, '青海省', '海东市', '630200');
INSERT INTO `province` VALUES (319, '青海省', '海北藏族自治州', '632200');
INSERT INTO `province` VALUES (320, '青海省', '海南藏族自治州', '632500');
INSERT INTO `province` VALUES (321, '青海省', '果洛藏族自治州', '632600');
INSERT INTO `province` VALUES (322, '青海省', '黄南藏族自治州', '632300');
INSERT INTO `province` VALUES (323, '宁夏回族自治区', '银川市', '640100');
INSERT INTO `province` VALUES (324, '青海省', '海西蒙古族藏族自治州', '632800');
INSERT INTO `province` VALUES (325, '青海省', '玉树藏族自治州', '632700');
INSERT INTO `province` VALUES (326, '宁夏回族自治区', '石嘴山市', '640200');
INSERT INTO `province` VALUES (327, '宁夏回族自治区', '固原市', '640400');
INSERT INTO `province` VALUES (328, '宁夏回族自治区', '吴忠市', '640300');
INSERT INTO `province` VALUES (329, '新疆维吾尔自治区', '乌鲁木齐市', '650100');
INSERT INTO `province` VALUES (330, '宁夏回族自治区', '中卫市', '640500');
INSERT INTO `province` VALUES (331, '新疆维吾尔自治区', '克拉玛依市', '650200');
INSERT INTO `province` VALUES (332, '新疆维吾尔自治区', '哈密市', '650500');
INSERT INTO `province` VALUES (333, '新疆维吾尔自治区', '吐鲁番市', '650400');
INSERT INTO `province` VALUES (334, '新疆维吾尔自治区', '昌吉回族自治州', '652300');
INSERT INTO `province` VALUES (335, '新疆维吾尔自治区', '巴音郭楞蒙古自治州', '652800');
INSERT INTO `province` VALUES (336, '新疆维吾尔自治区', '博尔塔拉蒙古自治州', '652700');
INSERT INTO `province` VALUES (337, '新疆维吾尔自治区', '阿克苏地区', '652900');
INSERT INTO `province` VALUES (338, '新疆维吾尔自治区', '克孜勒苏柯尔克孜自治州', '653000');
INSERT INTO `province` VALUES (339, '新疆维吾尔自治区', '喀什地区', '653100');
INSERT INTO `province` VALUES (340, '新疆维吾尔自治区', '伊犁哈萨克自治州', '654000');
INSERT INTO `province` VALUES (341, '新疆维吾尔自治区', '塔城地区', '654200');
INSERT INTO `province` VALUES (342, '新疆维吾尔自治区', '阿勒泰地区', '654300');
INSERT INTO `province` VALUES (343, '新疆维吾尔自治区', '自治区直辖县级行政区划', '659000');
INSERT INTO `province` VALUES (344, '台湾', '台湾', '999079');
INSERT INTO `province` VALUES (345, '新疆维吾尔自治区', '和田地区', '653200');
INSERT INTO `province` VALUES (346, '香港特别行政区', '特别行政区', '999077');
INSERT INTO `province` VALUES (347, '澳门特别行政区', '特别行政区', '999078');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `createAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updateAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (6, 'tes1t', '202cb962ac59075b964b07152d234b70', '2022-10-11 23:03:14', '2022-10-11 23:03:14');
INSERT INTO `user` VALUES (11, 'test', 'cc03e747a6afbbcbf8be7668acfebee5', '2022-10-12 10:36:40', '2022-10-12 16:41:08');
INSERT INTO `user` VALUES (12, 'wangdage', 'b4bda8956ee993d2463d761c37e64890', '2022-10-15 22:31:25', '2022-10-15 22:31:25');
INSERT INTO `user` VALUES (13, 'abc', 'e99a18c428cb38d5f260853678922e03', '2022-10-15 22:33:10', '2022-10-15 22:33:10');
INSERT INTO `user` VALUES (14, 'abcd', 'e99a18c428cb38d5f260853678922e03', '2022-10-15 22:34:19', '2022-10-15 22:34:19');
INSERT INTO `user` VALUES (15, 'test22', 'cc03e747a6afbbcbf8be7668acfebee5', '2022-10-23 21:46:32', '2022-10-23 21:46:32');
INSERT INTO `user` VALUES (16, 'test2', 'cc03e747a6afbbcbf8be7668acfebee5', '2022-10-24 00:23:26', '2022-10-24 00:23:26');

-- ----------------------------
-- Table structure for user_info
-- ----------------------------
DROP TABLE IF EXISTS `user_info`;
CREATE TABLE `user_info`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL,
  `nickname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `profile` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `country` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `area` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `telephone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `createAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updateAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  CONSTRAINT `user_info_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_info
-- ----------------------------
INSERT INTO `user_info` VALUES (1, 15, 'demo', 'demoavatar', '1212', '121212', '123123', '123123', 'demo22', '123', '12312', '2022-10-23 21:56:34', '2022-10-23 22:26:20');
INSERT INTO `user_info` VALUES (5, 11, 'springLoach', 'https://himg.bdimg.com/sys/portrait/item/public.1.9c514cd0.8wukqHg6lGH4a-Itk8mY-A.jpg', '1007435098@qq.com', '做想做的事', '中国', '广东省', '广州市', '璃月港', '86-18626', '2022-10-23 22:59:59', '2022-10-24 00:16:07');
INSERT INTO `user_info` VALUES (6, NULL, 'springLoach2', 'https://himg.bdimg.com/sys/portrait/item/public.1.9c514cd0.8wukqHg6lGH4a-Itk8mY-A.jpg', '1007435098@qq.com', '22', '中国', '北京市', '市辖区', '璃月港', '86-18626', '2022-10-24 00:37:57', '2022-10-24 00:37:57');
INSERT INTO `user_info` VALUES (7, NULL, 'springLoach2', 'https://himg.bdimg.com/sys/portrait/item/public.1.9c514cd0.8wukqHg6lGH4a-Itk8mY-A.jpg', '1007435098@qq.com', '22', '中国', '黑龙江省', '伊春市', '22', '2-2', '2022-10-24 00:40:37', '2022-10-24 00:40:37');
INSERT INTO `user_info` VALUES (8, NULL, 'springLoach2', 'https://himg.bdimg.com/sys/portrait/item/public.1.9c514cd0.8wukqHg6lGH4a-Itk8mY-A.jpg', '1007435098@qq.com', '22', '中国', '黑龙江省', '伊春市', '22', '2-2', '2022-10-24 00:42:21', '2022-10-24 00:42:21');
INSERT INTO `user_info` VALUES (9, 16, 'springLoach2', 'https://himg.bdimg.com/sys/portrait/item/public.1.9c514cd0.8wukqHg6lGH4a-Itk8mY-A.jpg', '1007435098@qq.com', '22', '中国', '广东省', '江门市', '22', '2-2', '2022-10-24 00:54:18', '2022-10-24 00:54:18');

SET FOREIGN_KEY_CHECKS = 1;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `account`;
CREATE TABLE `account`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `phone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱',
  `password` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `invite_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自己的邀请码',
  `inviter_id` bigint NULL DEFAULT NULL COMMENT 'phone表中谁邀请的',
  `chatgpt_user_id` bigint NULL DEFAULT NULL COMMENT '绑定的UserToken',
  `normal_expire_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '普通会员过期时间',
  `plus_expire_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT 'plus会员过期时间',
  `mail` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `login_token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自动登录Token',
  `register_datetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `partner_id` bigint NULL DEFAULT NULL COMMENT '合作商id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `phone`(`phone` ASC) USING BTREE,
  UNIQUE INDEX `invite_code`(`invite_code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `car_disable`;
CREATE TABLE `car_disable`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `car_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for carousel
-- ----------------------------
DROP TABLE IF EXISTS `carousel`;
CREATE TABLE `carousel`  (
  `priority` int NOT NULL COMMENT '轮播图优先级',
  `src` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片地址'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for claude_session
-- ----------------------------
DROP TABLE IF EXISTS `claude_session`;
CREATE TABLE `claude_session`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `createTime` datetime(3) NOT NULL COMMENT '创建时间',
  `updateTime` datetime(3) NOT NULL COMMENT '更新时间',
  `deleted_at` datetime(3) NULL DEFAULT NULL,
  `email` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱',
  `password` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '状态',
  `isPlus` tinyint(1) NULL DEFAULT 0 COMMENT 'PLUS',
  `carID` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '展示ID',
  `officialSession` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '官方session',
  `remark` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `sort` bigint NULL DEFAULT 0 COMMENT '排序',
  `count` bigint NULL DEFAULT 0 COMMENT '统计',
  `remaining` int NULL DEFAULT 0 COMMENT '剩余量',
  `resets_at` bigint NULL DEFAULT NULL COMMENT '重置时间戳',
  `disable` tinyint NULL DEFAULT 0 COMMENT '是否显示,1为不显示',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coupon
-- ----------------------------
DROP TABLE IF EXISTS `coupon`;
CREATE TABLE `coupon`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_id` bigint NOT NULL,
  `discount` int NOT NULL COMMENT '折扣',
  `create_time` datetime NOT NULL COMMENT '创建日期',
  `end_time` datetime NULL DEFAULT NULL COMMENT '截止日期',
  `threshold` int NULL DEFAULT 0 COMMENT '最低使用天数(包含)',
  `is_used` tinyint NULL DEFAULT 0 COMMENT '是否使用过',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for info_map
-- ----------------------------
DROP TABLE IF EXISTS `info_map`;
CREATE TABLE `info_map`  (
  `keyy` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通知的标识符',
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '通知的值',
  `remark` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`keyy`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;
LOCK TABLES `info_map` WRITE;

INSERT INTO `info_map` VALUES ('alert', '123', '弹窗通知');
INSERT INTO `info_map` VALUES ('buy', '<el-card shadow=\"hover\" class=\"animate__animated animate__lightSpeedInLeft animate__delay-100ms\"> \n	<el-text tag=\"b\">升级PLUS会员，立享以下功能</el-text>\n	<div style=\"display: flex;\n  justify-content: center;\n  align-items: center;\n  text-align: center;\">\n	<ul style=\"padding: 0;margin-bottom: 0;\">\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n			<el-text tag=\"b\">✨GPT 4o - 当前全网最强的AI对话大模型，没有之一，强大之处谁用谁知道！</el-text>\n        </li>\n\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <el-text tag=\"b\">📐绘图Dall-e-3 - 堪比Midjourney，从此你拥有一个乙方设计师，随时下需求！</el-text>\n        </li>\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <el-text tag=\"b\">📌图片识别 - 把自行车坏的部位拍给他，会直接告诉你怎么修，就是这么强大！</el-text>\n        </li>\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <el-text tag=\"b\">🌐联网搜索 - 获取实时信息，无论是最新新闻还是刚刚发生的某产品发布会，统统都有！</el-text>\n        </li>\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <el-text tag=\"b\">🚀文件上传 -  Excel、TXT、PDF...统统可以扔进去，成为你数据的一部分！</el-text>\n        </li>\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <el-text tag=\"b\">📊数据分析 - 丢给他数据，直接出图表！数据分析者必备工具，效率upup！</el-text>\n        </li>\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <el-text tag=\"b\">🧊插件 - 维基百科、PDF对话、AI总结论文、获取文献... 成千上百插件等你探索！</el-text>\n        </li>\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <el-text tag=\"b\">🧱All tools - 集合GPT全部功能！对话+绘画+联网+分析... 一应俱全！</el-text>\n        </li>\n		<li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <el-text tag=\"b\">☁️Claude - 堪比GPT 4o！在动态工作区中实时查看你的作品，甚至运行游戏！</el-text>\n        </li>\n	</ul>\n	\n	</div>\n</el-card>\n\n<el-card shadow=\"hover\" class=\"animate__animated animate__lightSpeedInLeft animate__delay-200ms\"> \n	<el-text>支付有一定延时，支付完毕请耐心等待系统响应。支付成功后请进入个人中心使用。</el-text>\n</el-card>\n\n<el-card shadow=\"hover\" class=\"animate__animated animate__lightSpeedInLeft animate__delay-300ms\"> \n	<el-text>销售只是起点，售后没有终点。建议及时加入</el-text>\n	<el-popover\n      :width=\"150\"\n    >\n      <template #reference>\n        <el-link type=\"primary\" style=\"color:\">交流群</el-link>\n      </template>\n      <template #default>\n        <el-image src=\"/job/1726308104444-qq_qun.svg\">\n			<template #error>\n			  <el-text>群二维码加载失败，请手动查找qq群：10086</el-text>\n			</template>\n		</el-image>\n      </template>\n    </el-popover>\n	<el-text>，任何会员都享有<span style=\"color:red\">售后服务</span>直到会员到期。</el-text>\n</el-card>\n', '购买通知');
INSERT INTO `info_map` VALUES ('criteria', '', '系统使用准则');
INSERT INTO `info_map` VALUES ('me', '<el-card shadow=\"hover\" class=\"animate__animated animate__lightSpeedInRight animate__delay-100ms\">\r\n  <el-text>未使用的激活码将会<span style=\"color:red\">永久保留</span>直至使用，使用后会在现有时长上延期</el-text>\r\n</el-card>\r\n\r\n<el-card shadow=\"hover\" class=\"animate__animated animate__lightSpeedInRight animate__delay-200ms\">\r\n  <el-text>PLUS会员激活码属于虚拟商品，一经与您的账号绑定，将不支持退款</el-text>\r\n</el-card>\r\n\r\n<el-card shadow=\"hover\" class=\"animate__animated animate__lightSpeedInRight animate__delay-300ms\">\r\n  <el-text><span style=\"color:red\">邀请返利</span>规则：如果对方填写你的邀请码进行注册，那么你会获得Ta们后续在本站购买所得的PLUS会员时长的<span style=\"color:red\">5%</span>，返利获得的激活码可在个人中心查看并使用。比如B通过A的邀请码进行注册，如果B购买了100天的PLUS会员，那么A立即获得时长为5天(120小时)的激活码；如果B又购买了7天的会员，那么A立即获得时长为0.35天(9小时)的激活码。返利不限次数，返利时长用小时计算，向上取整，购买1天或1天以上才可返利。</el-text>\r\n</el-card>\r\n\r\n\r\n', '个人中心');
INSERT INTO `info_map` VALUES ('notice', '123', '通知');
INSERT INTO `info_map` VALUES ('usage', '<el-card shadow=\"hover\" class=\"animate__animated animate__lightSpeedInRight animate__delay-100ms\"> \n	<el-text>新用户注册立享：4小时普通会员激活码+4小时Plus会员激活码！使用前请<span style=\"color:red\">仔细阅读</span>下列使用说明。</el-text>\n</el-card>\n\n<el-card shadow=\"hover\" class=\"animate__animated animate__lightSpeedInRight animate__delay-200ms\">\n	<div><el-text>本站<span style=\"color:red;font-size:22px\">免费</span>提供ChatGPT普通账号。</el-text></div>\n	<div>\n		<el-text>本站每月续订ChatGPT PLUS账号的成本十分高昂！因此ChatGPT PLUS账号需付费成为PLUS会员才能使用！价格仅为ChatGPT官网的<span style=\"color:red\">五分之一</span>！</el-text>\n	</div>\n</el-card>\n\n<el-card shadow=\"hover\" class=\"animate__animated animate__lightSpeedInRight animate__delay-300ms\">\n\n				<div>\n					<el-text >账号列表中的所有ChatGPT账号、Claude账号均为官网<span style=\"color:red\">正规账号</span>，点击任意账号即可进入官网对话界面。</el-text>\n				</div>\n\n				<el-text>\n					<el-tag \n					style=\"\n						background: linear-gradient(90deg, #ff5f6d, #8e2de2);\n						border: none;\n						color: white;\n						font-weight: bold;\n						border-radius: 15px;\n						text-align: center;\n						padding: 2px 10px;\" class=\"car-type car-plus\">\n						PLUS\n					</el-tag>\n				表示该账号是ChatGPT的PLUS订阅账号，可以使用全部模型包括GPT-4o mini、GPT-4、GPT-4o。\n				</el-text>\n\n				<el-text>\n					<el-tag style=\"\n						background: linear-gradient(90deg, #ff5858, #fb8b24);;\n						border: none;\n						color: white;\n						font-weight: bold;\n						border-radius: 15px;\n						text-align: center;\n						padding: 2px 10px;\" class=\"car-type car-normal\">\n					mini\n					</el-tag>\n				表示该账号是ChatGPT的普通账号，GPT-4o mini模型无使用限制，GPT-4o模型每日可少量使用。<span style=\"color:red\">特别说明：普通账号中的GPT-4选项为显示bug，实际调用的模型是GPT-4o mini。</span></el-text>\n\n				<el-text>\n					<el-tag style=\"\n						background: linear-gradient(90deg, #e0e0e0, #b0b0b0);\n						border: none;\n						color: white;\n						font-weight: bold;\n						border-radius: 15px;\n						text-align: center;\n						padding: 2px 10px;\" class=\"car-type car-normal\">\n					claude\n					</el-tag>\n				表示该账号是Claude账号。</el-text>\n\n\n</el-card>\n\n\n\n\n\n<el-card shadow=\"hover\" class=\"animate__animated animate__lightSpeedInRight animate__delay-400ms\">\n\n				<el-text>\n				<el-tag>空闲|推荐</el-tag>\n				表示该账号使用人数很少，推荐使用。</el-text>\n\n				<el-text >\n				<el-tag type=\"warning\">繁忙|可用</el-tag>\n				表示该账号3小时内对话次数大于20次</el-text>\n\n				<el-text >\n				<el-tag type=\"error\">翻车|不可用</el-tag>\n				表示该账号已无法使用。</el-text>\n\n				<el-text >\n				<el-tag type=\"error\">停运</el-tag>\n				表示该账号达到官网对话次数限制暂时不可用。</el-text>\n	\n				<div>\n					<el-text>系统已对账号进行排序，若无特殊需求，直接选择第一个账号进入即可。</el-text>\n				</div>\n\n				<div>\n					<el-text>如果一个账号达到使用次数限制，请点击对话界面右上角的\n					<div style=\"border-top-left-radius: 34px; border-bottom-left-radius: 34px; background: linear-gradient(140.91deg, rgb(255, 135, 183) 12.61%, rgb(236, 76, 140) 76.89%); min-height: 34px; min-width: 45px; margin: 1px; display: inline-flex; align-items: center;cursor: pointer;\"><span style=\"color:white;font-size:15px;margin-left:10px\">换号</span></div>\n					\n					重新选择一个账号使用。\n					</el-text>\n					\n				</div>\n</el-card>\n\n<el-card shadow=\"hover\"\n                    class=\"animate__animated animate__lightSpeedInRight animate__delay-500ms\">\n                    <el-text>为避免突发状况导致网站无法访问，建议加入</el-text>\n                    <el-popover :width=\"150\">\n                        <template #reference>\n                            <el-link type=\"primary\">交流群</el-link>\n                        </template>\n                        <template #default>\n                            <el-image src=\"/job/1726308104444-qq_qun.svg\">\n                                <template #error>\n                                    <el-text>群二维码加载失败，请手动查找qq群：10086</el-text>\n                                </template>\n                            </el-image>\n                        </template>\n                    </el-popover>\n                    <el-text></el-text>\n                </el-card>\n\n\n                <el-card shadow=\"hover\"\n                    class=\"animate__animated animate__lightSpeedInRight animate__delay-600ms\">\n                    <el-popover :width=\"120\">\n                        <template #reference>\n                            <el-link type=\"primary\">安卓APP下载</el-link>\n                        </template>\n                        <template #default>\n                            <el-image style=\"width:100%\" src=\"/job/1726304746355-app_download_qrcode.svg\">\n                            </el-image>\n\n                            <el-link target=\"_blank\" href=\"/job/1726304626121-much-ai.apk\">\n                                <el-button type=\"primary\" style=\"width: 125px; color: white;\">\n                                    下载\n                                </el-button>\n                            </el-link>\n                        </template>\n                    </el-popover>\n                    &nbsp&nbsp&nbsp\n\n\n                            <el-link type=\"primary\" style=\"width:120px\" target=\"_blank\" href=\"https://wwjb.lanzouv.com/idqB929zklcf\">\n                                  Windows下载\n                            </el-link>\n                </el-card>', '使用说明');

UNLOCK TABLES;

-- ----------------------------
-- Table structure for item
-- ----------------------------
DROP TABLE IF EXISTS `item`;
CREATE TABLE `item`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '商品编号',
  `item_category_id` int NOT NULL COMMENT '分类编号',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `isPlus` tinyint NOT NULL COMMENT '是否plus',
  `duration` int NOT NULL COMMENT '有效时长(小时)',
  `price` decimal(10, 2) NOT NULL COMMENT '价格',
  `detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详情',
  `inventory` int NOT NULL COMMENT '库存',
  `able` tinyint NOT NULL COMMENT '是否可用',
  `priority` int NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

LOCK TABLES `item` WRITE;

INSERT INTO `item` VALUES (2, 1, '1天', 1, 24, 2.50, '', 100, 1, 2);
INSERT INTO `item` VALUES (4, 1, '30天', 1, 720, 45.00, '', 100, 1, 4);
INSERT INTO `item` VALUES (28, 14, '30天', 1, 720, 40.00, '', 0, 1, 0);
INSERT INTO `item` VALUES (29, 14, '90天', 1, 2160, 114.00, '', 0, 1, 0);
INSERT INTO `item` VALUES (30, 14, '1年', 1, 8640, 399.00, '', 0, 1, 0);
INSERT INTO `item` VALUES (31, 14, '2年', 1, 17280, 699.00, '', 0, 1, 0);

UNLOCK TABLES;

-- ----------------------------
-- Table structure for item_category
-- ----------------------------
DROP TABLE IF EXISTS `item_category`;
CREATE TABLE `item_category`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '编号',
  `priority` int NOT NULL DEFAULT 1 COMMENT '优先级，越小展示越靠前',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `detail` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '详情',
  `img` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '图片路径',
  `able` tinyint NULL DEFAULT 1 COMMENT '是否显示',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

LOCK TABLES `item_category` WRITE;

INSERT INTO `item_category` VALUES (1, 2, 'PLUS会员', '<ul style=\"list-style: none; padding: 0;\">\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <span style=\"color: #5D87FF; margin-right: 10px;\"><svg focusable=\"false\" data-icon=\"check\" width=\"1em\" height=\"1em\" fill=\"currentColor\" aria-hidden=\"true\" viewBox=\"64 64 896 896\"><path d=\"M912 190h-69.9c-9.8 0-19.1 4.5-25.1 12.2L404.7 724.5 207 474a32 32 0 00-25.1-12.2H112c-6.7 0-10.4 7.7-6.3 12.9l273.9 347c12.8 16.2 37.4 16.2 50.3 0l488.4-618.9c4.1-5.1.4-12.8-6.3-12.8z\"></path></svg></span> 全部PLUS账号\n        </li>\n\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <span style=\"color: #5D87FF; margin-right: 10px;\"><svg focusable=\"false\" data-icon=\"check\" width=\"1em\" height=\"1em\" fill=\"currentColor\" aria-hidden=\"true\" viewBox=\"64 64 896 896\"><path d=\"M912 190h-69.9c-9.8 0-19.1 4.5-25.1 12.2L404.7 724.5 207 474a32 32 0 00-25.1-12.2H112c-6.7 0-10.4 7.7-6.3 12.9l273.9 347c12.8 16.2 37.4 16.2 50.3 0l488.4-618.9c4.1-5.1.4-12.8-6.3-12.8z\"></path></svg></span> GPT-4o mini\n        </li>\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <span style=\"color: #5D87FF; margin-right: 10px;\"><svg focusable=\"false\" data-icon=\"check\" width=\"1em\" height=\"1em\" fill=\"currentColor\" aria-hidden=\"true\" viewBox=\"64 64 896 896\"><path d=\"M912 190h-69.9c-9.8 0-19.1 4.5-25.1 12.2L404.7 724.5 207 474a32 32 0 00-25.1-12.2H112c-6.7 0-10.4 7.7-6.3 12.9l273.9 347c12.8 16.2 37.4 16.2 50.3 0l488.4-618.9c4.1-5.1.4-12.8-6.3-12.8z\"></path></svg></span> GPT-4\n        </li>\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <span style=\"color: #5D87FF; margin-right: 10px;\"><svg focusable=\"false\" data-icon=\"check\" width=\"1em\" height=\"1em\" fill=\"currentColor\" aria-hidden=\"true\" viewBox=\"64 64 896 896\"><path d=\"M912 190h-69.9c-9.8 0-19.1 4.5-25.1 12.2L404.7 724.5 207 474a32 32 0 00-25.1-12.2H112c-6.7 0-10.4 7.7-6.3 12.9l273.9 347c12.8 16.2 37.4 16.2 50.3 0l488.4-618.9c4.1-5.1.4-12.8-6.3-12.8z\"></path></svg></span> GPT-4o\n        </li>\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <span style=\"color: #5D87FF; margin-right: 10px;\"><svg focusable=\"false\" data-icon=\"check\" width=\"1em\" height=\"1em\" fill=\"currentColor\" aria-hidden=\"true\" viewBox=\"64 64 896 896\"><path d=\"M912 190h-69.9c-9.8 0-19.1 4.5-25.1 12.2L404.7 724.5 207 474a32 32 0 00-25.1-12.2H112c-6.7 0-10.4 7.7-6.3 12.9l273.9 347c12.8 16.2 37.4 16.2 50.3 0l488.4-618.9c4.1-5.1.4-12.8-6.3-12.8z\"></path></svg></span> GPT-GPTS\n        </li>\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <span style=\"color: #5D87FF; margin-right: 10px;\"><svg focusable=\"false\" data-icon=\"check\" width=\"1em\" height=\"1em\" fill=\"currentColor\" aria-hidden=\"true\" viewBox=\"64 64 896 896\"><path d=\"M912 190h-69.9c-9.8 0-19.1 4.5-25.1 12.2L404.7 724.5 207 474a32 32 0 00-25.1-12.2H112c-6.7 0-10.4 7.7-6.3 12.9l273.9 347c12.8 16.2 37.4 16.2 50.3 0l488.4-618.9c4.1-5.1.4-12.8-6.3-12.8z\"></path></svg></span> GPT-Dalle-3\n        </li>\n		<li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <span style=\"color:red\">[赠]</span> Claude-3.5 Sonnet\n        </li>\n    </ul>', '', 1);
INSERT INTO `item_category` VALUES (14, 0, '国庆特惠', '<ul style=\"list-style: none; padding: 0;\">\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <span style=\"color: #5D87FF; margin-right: 10px;\"><svg focusable=\"false\" data-icon=\"check\" width=\"1em\" height=\"1em\" fill=\"currentColor\" aria-hidden=\"true\" viewBox=\"64 64 896 896\"><path d=\"M912 190h-69.9c-9.8 0-19.1 4.5-25.1 12.2L404.7 724.5 207 474a32 32 0 00-25.1-12.2H112c-6.7 0-10.4 7.7-6.3 12.9l273.9 347c12.8 16.2 37.4 16.2 50.3 0l488.4-618.9c4.1-5.1.4-12.8-6.3-12.8z\"></path></svg></span> 全部PLUS账号\n        </li>\n\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <span style=\"color: #5D87FF; margin-right: 10px;\"><svg focusable=\"false\" data-icon=\"check\" width=\"1em\" height=\"1em\" fill=\"currentColor\" aria-hidden=\"true\" viewBox=\"64 64 896 896\"><path d=\"M912 190h-69.9c-9.8 0-19.1 4.5-25.1 12.2L404.7 724.5 207 474a32 32 0 00-25.1-12.2H112c-6.7 0-10.4 7.7-6.3 12.9l273.9 347c12.8 16.2 37.4 16.2 50.3 0l488.4-618.9c4.1-5.1.4-12.8-6.3-12.8z\"></path></svg></span> GPT-4o mini\n        </li>\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <span style=\"color: #5D87FF; margin-right: 10px;\"><svg focusable=\"false\" data-icon=\"check\" width=\"1em\" height=\"1em\" fill=\"currentColor\" aria-hidden=\"true\" viewBox=\"64 64 896 896\"><path d=\"M912 190h-69.9c-9.8 0-19.1 4.5-25.1 12.2L404.7 724.5 207 474a32 32 0 00-25.1-12.2H112c-6.7 0-10.4 7.7-6.3 12.9l273.9 347c12.8 16.2 37.4 16.2 50.3 0l488.4-618.9c4.1-5.1.4-12.8-6.3-12.8z\"></path></svg></span> GPT-4\n        </li>\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <span style=\"color: #5D87FF; margin-right: 10px;\"><svg focusable=\"false\" data-icon=\"check\" width=\"1em\" height=\"1em\" fill=\"currentColor\" aria-hidden=\"true\" viewBox=\"64 64 896 896\"><path d=\"M912 190h-69.9c-9.8 0-19.1 4.5-25.1 12.2L404.7 724.5 207 474a32 32 0 00-25.1-12.2H112c-6.7 0-10.4 7.7-6.3 12.9l273.9 347c12.8 16.2 37.4 16.2 50.3 0l488.4-618.9c4.1-5.1.4-12.8-6.3-12.8z\"></path></svg></span> GPT-4o\n        </li>\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <span style=\"color: #5D87FF; margin-right: 10px;\"><svg focusable=\"false\" data-icon=\"check\" width=\"1em\" height=\"1em\" fill=\"currentColor\" aria-hidden=\"true\" viewBox=\"64 64 896 896\"><path d=\"M912 190h-69.9c-9.8 0-19.1 4.5-25.1 12.2L404.7 724.5 207 474a32 32 0 00-25.1-12.2H112c-6.7 0-10.4 7.7-6.3 12.9l273.9 347c12.8 16.2 37.4 16.2 50.3 0l488.4-618.9c4.1-5.1.4-12.8-6.3-12.8z\"></path></svg></span> GPT-GPTS\n        </li>\n        <li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <span style=\"color: #5D87FF; margin-right: 10px;\"><svg focusable=\"false\" data-icon=\"check\" width=\"1em\" height=\"1em\" fill=\"currentColor\" aria-hidden=\"true\" viewBox=\"64 64 896 896\"><path d=\"M912 190h-69.9c-9.8 0-19.1 4.5-25.1 12.2L404.7 724.5 207 474a32 32 0 00-25.1-12.2H112c-6.7 0-10.4 7.7-6.3 12.9l273.9 347c12.8 16.2 37.4 16.2 50.3 0l488.4-618.9c4.1-5.1.4-12.8-6.3-12.8z\"></path></svg></span> GPT-Dalle-3\n        </li>\n		<li style=\"display: flex; align-items: center; margin-bottom: 10px;\">\n            <span style=\"color:red\">[赠]</span> Claude-3.5 Sonnet\n        </li>\n    </ul>', NULL, 1);

UNLOCK TABLES;

-- ----------------------------
-- Table structure for job_config
-- ----------------------------
DROP TABLE IF EXISTS `job_config`;
CREATE TABLE `job_config`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'key',
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'value'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;


LOCK TABLES `job_config` WRITE;

INSERT INTO `job_config` VALUES ('alipayAppId', '');
INSERT INTO `job_config` VALUES ('alipayNotifyUrl', ' https://demo.075114.xyz/job/notify');
INSERT INTO `job_config` VALUES ('alipayPrivateKey', '');
INSERT INTO `job_config` VALUES ('alipayPublicKey', '');
INSERT INTO `job_config` VALUES ('alipayReturnUrl', '');
INSERT INTO `job_config` VALUES ('aliSmsAccessKeyId', '');
INSERT INTO `job_config` VALUES ('aliSmsAccessKeySecret', '');
INSERT INTO `job_config` VALUES ('aliSmsFindPasswordTemplateCode', '');
INSERT INTO `job_config` VALUES ('aliSmsRegisterTemplateCode', '');
INSERT INTO `job_config` VALUES ('aliSmsSignName', '');
INSERT INTO `job_config` VALUES ('differenceRate', '80');
INSERT INTO `job_config` VALUES ('principalRate', '15');
INSERT INTO `job_config` VALUES ('qqMailAccount', '');
INSERT INTO `job_config` VALUES ('qqMailPassword', '');
INSERT INTO `job_config` VALUES ('registerGiveCoupon', '90');
INSERT INTO `job_config` VALUES ('registerGiveCouponEnable', 'true');
INSERT INTO `job_config` VALUES ('registerGivePlus', '24');
INSERT INTO `job_config` VALUES ('registerGivePlusEnable', 'true');
INSERT INTO `job_config` VALUES ('antiSbAli', 'false');
INSERT INTO `job_config` VALUES ('title', 'ChatGPT共享站');
INSERT INTO `job_config` VALUES ('registerWay', 'none');
INSERT INTO `job_config` VALUES ('mallEnable', 'true');
INSERT INTO `job_config` VALUES ('freeNormalEnable', 'false');
INSERT INTO `job_config` VALUES ('registerGiveNormalEnable', 'true');
INSERT INTO `job_config` VALUES ('registerGiveNormal', '24');
INSERT INTO `job_config` VALUES ('virtualCarEnable', 'false');
INSERT INTO `job_config` VALUES ('virtualPlusCarAmount', '7');
INSERT INTO `job_config` VALUES ('virtualMiniCarAmount', '7');
INSERT INTO `job_config` VALUES ('virtualPlusCarSplit', '');
INSERT INTO `job_config` VALUES ('returnRate', '5');
INSERT INTO `job_config` VALUES ('plusRateLimit', '{\n    \"gpt-4,gpt-4o,gpt-4-browsing,gpt-4-plugins,gpt-4-mobile,gpt-4-code-interpreter,gpt-4-dalle,gpt-4-gizmo,gpt-4-magic-create\":[\"80\",\"3h\"],\n    \"o1-preview,o1-mini\":[\"10\",\"1w\"],\n    \"gpt-4o-mini\":[\"10\",\"1h\"]\n}');
INSERT INTO `job_config` VALUES ('normalRateLimit', '{\n\"auto,gpt-4o-mini,o1-preview,o1-mini,gpt-4,gpt-4o,gpt-4-browsing,gpt-4-plugins,gpt-4-mobile,gpt-4-code-interpreter,gpt-4-dalle,gpt-4-gizmo,gpt-4-magic-create\":[\"3\",\"2m\"]\n}');
INSERT INTO `job_config` VALUES ('forbiddenWords', '');
INSERT INTO `job_config` VALUES ('mailWhitelist', '163.com,126.com,qq.com,hotmail.com,outlook.com,yahoo.com,foxmail.com,icloud.com,gmail.com');

UNLOCK TABLES;

-- ----------------------------
-- Table structure for mail_check_code
-- ----------------------------
DROP TABLE IF EXISTS `mail_check_code`;
CREATE TABLE `mail_check_code`  (
  `mail` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱',
  `check_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '验证码',
  `end_time` datetime NOT NULL COMMENT '验证码到期时间',
  `ip` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '请求ip',
  `used` tinyint NULL DEFAULT 0 COMMENT '是否使用',
  PRIMARY KEY (`mail`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for partner
-- ----------------------------
DROP TABLE IF EXISTS `partner`;
CREATE TABLE `partner`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `domain` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `config` json NULL COMMENT '配置',
  `total_earned` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总收入',
  `rest_earned` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '剩余',
  `login_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`, `domain`, `username`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for phone_check_code
-- ----------------------------
DROP TABLE IF EXISTS `phone_check_code`;
CREATE TABLE `phone_check_code`  (
  `phone` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `check_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '验证码',
  `end_time` datetime NOT NULL COMMENT '验证码生成时间',
  `ip` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '请求IP',
  `used` tinyint NULL DEFAULT 0,
  PRIMARY KEY (`phone`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for trade
-- ----------------------------
DROP TABLE IF EXISTS `trade`;
CREATE TABLE `trade`  (
  `trade_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '交易号',
  `item_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名',
  `isPlus` tinyint NOT NULL COMMENT '是否plus',
  `duration` int NOT NULL COMMENT '购买时长',
  `origin_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原价',
  `price` decimal(10, 2) NOT NULL COMMENT '价格',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付完成时间',
  `account_id` bigint NULL DEFAULT NULL COMMENT '购买用户的id',
  `user_not_used_id` bigint NULL DEFAULT NULL COMMENT '未使用的usertoken表中的id',
  `coupon_id` bigint NULL DEFAULT NULL COMMENT '优惠券id',
  `partner_id` bigint NULL DEFAULT NULL COMMENT '不为空则来自合作商',
  `price_multiple` decimal(10, 2) NULL DEFAULT NULL COMMENT '合作商价格倍率',
  `partner_origin_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '合作方原价',
  `partner_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '合作商最终价格',
  `principal_rate` decimal(10, 2) NULL DEFAULT NULL COMMENT '站长设置的本金返利比例',
  `difference_rate` decimal(10, 2) NULL DEFAULT NULL COMMENT '站长设置的差额返利比例',
  `principal_profit` decimal(10, 2) NULL DEFAULT NULL COMMENT '本金返利收益',
  `difference_profit` decimal(10, 2) NULL DEFAULT NULL COMMENT '差额返利收益',
  `total_profit` decimal(10, 2) NULL DEFAULT NULL COMMENT '总收益',
  PRIMARY KEY (`trade_no`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_token_not_used
-- ----------------------------
DROP TABLE IF EXISTS `user_token_not_used`;
CREATE TABLE `user_token_not_used`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `userToken` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '未使用过的userToken',
  `duration` int NOT NULL COMMENT '可用时间。小时为单位',
  `isPlus` tinyint(1) NOT NULL COMMENT '是否plus',
  `is_used` tinyint NULL DEFAULT 0 COMMENT '用过没有',
  `is_create_by_admin` tinyint NULL DEFAULT 0 COMMENT '是不是管理员生成的',
  `account_id` bigint NULL DEFAULT NULL COMMENT '导入到谁的账号',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `use_time` datetime NULL DEFAULT NULL COMMENT '使用时间',
  `access` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '获取方式',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;



INSERT INTO user_token_not_used (userToken, duration, isPlus, is_used, is_create_by_admin, account_id, create_time, access)
SELECT 
    cu.userToken, 
    CEIL(TIMESTAMPDIFF(HOUR, NOW(), cu.expireTime)) AS duration, 
    cu.isPlus, 
    0 AS is_used, 
    0 AS is_create_by_admin, 
    NULL AS account_id, 
    NOW() AS create_time, 
    '购买获得' AS access
FROM 
    chatgpt_user cu
WHERE 
    cu.expireTime > NOW();


SET FOREIGN_KEY_CHECKS = 1;




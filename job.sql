SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `account`;
CREATE TABLE `account`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `phone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱',
  `password` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
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
) ENGINE = InnoDB AUTO_INCREMENT = 853 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `car_disable`;
CREATE TABLE `car_disable`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `car_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1840311976148381699 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 821 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for job_config
-- ----------------------------
DROP TABLE IF EXISTS `job_config`;
CREATE TABLE `job_config`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'key',
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'value'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;


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
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `domain` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `config` json NULL COMMENT '配置',
  `total_earned` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总收入',
  `rest_earned` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '剩余',
  `login_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`, `domain`, `username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 6852 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;

# 新能源汽车销售系统-环境配置说明

## 一、拉取项目

```bash
git clone -b AddNewMoudle https://github.com/HouKeqi/carsale.git
```

## 二、前端配置及启动

node.js需要较高的版本 18.18.0以上

```bash
cd carsale-frontend
npm install    # 首次需要
npm run dev
```

## 三、执行数据库文件

```sql
-- 创建数据库
CREATE DATABASE `ry-vue` DEFAULT CHARACTER SET utf8mb4;

-- 导入脚本：carsale/新能源汽车销售系统/sql/init0124.sql
```

## 四、后端配置及启动

1. 修改数据库配置

   文件：carsale/新能源汽车销售系统/ruoyi-admin/src/main/resources/application-druid.yml

   ```yaml
   url:jdbc:mysql://localhost:3306/ry-vue(你的仓库名)
   username: root（用户名）
   password: 123456（密码）
   ```

2. 在application.yml后面加一段内容 由于包含 **阿里云 AccessKey 密钥**，因此不可添加到文件里面推送 

   ```yaml
   # 阿里云OSS配置
   aliyun:
     oss:         # 替换为你的Bucket名称
       # OSS endpoint，如：oss-cn-hangzhou.aliyuncs.com
       endpoint: oss-cn-beijing.aliyuncs.com
       # AccessKey ID
       accessKeyId: ×××
       # AccessKey Secret
       accessKeySecret: ×××
       # Bucket名称
       bucketName: sky-bucket-for-zdp
       # OSS访问URL前缀，格式：https://{bucketName}.{endpoint}
       urlPrefix: https://sky-bucket-for-zdp.oss-cn-beijing.aliyuncs.com
   ```

3. 启动Redis服务

4. IDEA中运行 RuoYiApplication.java

## 五、账号密码

| 账号  | 密码     |
| ----- | -------- |
| admin | admin123 |
| user  | 123456   |

##   

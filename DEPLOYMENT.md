# Boss直聘风格招聘平台 - 部署指南

## 一、环境要求

### 后端
- Java 17+
- Maven 3.8+
- MySQL 8.0+

### 前端
- Flutter 3.16+
- Dart SDK
- Android Studio / Xcode（移动端开发）

## 二、后端部署

### 1. 数据库初始化

```bash
# 登录MySQL
mysql -u root -p

# 执行初始化脚本
source database/init.sql
```

### 2. 配置文件

修改 `java_backend/src/main/resources/application.yml`：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/boss_recruitment
    username: your_username
    password: your_password

jwt:
  secret: your-secret-key-here
```

### 3. 启动后端

```bash
cd java_backend

# 使用Maven启动
mvn clean install
mvn spring-boot:run

# 或使用Jar包
mvn package
java -jar target/recruitment-backend-1.0.0.jar
```

后端将运行在：`http://localhost:8080`

API文档访问：`http://localhost:8080/swagger-ui.html`

## 三、前端部署

### 1. 安装依赖

```bash
cd flutter_app
flutter pub get
```

### 2. 生成代码（JSON序列化）

```bash
flutter pub run build_runner build
```

### 3. 配置API地址

修改 `lib/services/api_service.dart` 中的 `baseUrl`：

```dart
static const String baseUrl = 'http://your-backend-ip:8080/api';
```

### 4. 运行应用

#### Android
```bash
flutter run
```

#### iOS
```bash
flutter run
```

#### 生成APK
```bash
flutter build apk --release
```

#### 生成iOS包
```bash
flutter build ios --release
```

## 四、主要API接口

### 认证接口
- POST `/api/auth/code` - 获取验证码
- POST `/api/auth/login` - 用户登录
- GET `/api/auth/me` - 获取当前用户

### 职位接口
- GET `/api/jobs` - 获取职位列表
- GET `/api/jobs/{id}` - 获取职位详情
- GET `/api/jobs/hot` - 获取热门职位

## 五、测试账号

### 模拟登录
- 手机号：任意11位
- 验证码：123456（后端模拟）

## 六、注意事项

1. **CORS配置**：后端已配置允许跨域访问
2. **JWT密钥**：生产环境请修改为安全的密钥
3. **数据库**：确保MySQL使用utf8mb4字符集
4. **网络权限**：Flutter需要配置网络访问权限

### Android网络权限
在 `android/app/src/main/AndroidManifest.xml` 添加：
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### iOS网络权限
在 `ios/Runner/Info.plist` 添加：
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## 七、常见问题

### 1. 数据库连接失败
- 检查MySQL服务是否启动
- 验证数据库用户名密码
- 确认数据库已创建

### 2. Flutter编译错误
- 执行 `flutter clean`
- 重新运行 `flutter pub get`
- 检查Flutter版本是否>=3.16

### 3. API调用失败
- 检查后端服务是否启动
- 验证API地址配置是否正确
- 查看网络权限是否开启

## 八、性能优化建议

1. **后端**
   - 使用Redis缓存热门数据
   - 数据库查询添加索引
   - 启用API接口限流

2. **前端**
   - 图片使用CDN加载
   - 实现本地缓存（Hive/SQLite）
   - 优化列表滚动性能

## 九、下一步开发

- [ ] 实现在线聊天功能
- [ ] 添加简历编辑功能
- [ ] 实现收藏和投递功能
- [ ] 添加推送通知
- [ ] 实现鸿蒙系统适配

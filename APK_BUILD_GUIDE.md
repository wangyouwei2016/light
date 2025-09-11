# LuvGlow Android APK 构建指南

## 方法1：使用在线工具（推荐）

### 1. 使用 PWA Builder
1. 访问 https://www.pwabuilder.com/
2. 输入你的网站URL: `https://wangyouwei2016.github.io/light/`
3. 点击"Start"分析网站
4. 选择"Android"平台
5. 配置应用设置：
   - App Name: LuvGlow
   - Package Name: com.luvglow.app
   - 启用"Keep Screen On"选项
6. 下载生成的APK文件

### 2. 使用 Capacitor（本地构建）

#### 安装依赖
```bash
# 安装Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# 安装Capacitor CLI
npm install -g @capacitor/cli

# 安装Android Studio或者只安装Android SDK
```

#### 创建项目
```bash
# 创建新的Capacitor项目
npm init @capacitor/app luvglow-app

# 进入项目目录
cd luvglow-app

# 复制网站文件到www目录
cp /home/ec2-user/light/android-index.html www/index.html

# 添加Android平台
npx cap add android

# 安装防锁屏插件
npm install @capacitor-community/keep-awake
```

#### 配置防锁屏
在 `capacitor.config.ts` 中添加：
```typescript
import { CapacitorConfig } from '@capacitor/core';

const config: CapacitorConfig = {
  appId: 'com.luvglow.app',
  appName: 'LuvGlow',
  webDir: 'www',
  plugins: {
    KeepAwake: {
      enabled: true
    }
  }
};

export default config;
```

#### 构建APK
```bash
# 同步文件
npx cap sync

# 构建APK
npx cap build android

# 或者在Android Studio中打开项目
npx cap open android
```

## 方法2：使用 Cordova（已准备好的文件）

我已经为你准备了Android版本的HTML文件：`android-index.html`

### 特点：
- ✅ 防锁屏功能
- ✅ 完整的氛围灯效果
- ✅ 计时器功能
- ✅ 音效播放
- ✅ 日历记录（使用localStorage）
- ✅ 适配Android设备

### 使用步骤：
1. 安装Android Studio
2. 创建新的Cordova项目
3. 替换www/index.html为android-index.html
4. 添加防锁屏插件：`cordova plugin add cordova-plugin-insomnia`
5. 构建APK：`cordova build android`

## 方法3：直接下载现成的APK

如果你不想自己构建，可以：

1. 使用手机浏览器访问 https://wangyouwei2016.github.io/light/
2. 在Chrome中选择"添加到主屏幕"
3. 这会创建一个类似原生应用的快捷方式

## 防锁屏设置

无论使用哪种方法，都需要确保：

1. **应用权限**：在Android设置中给应用"保持唤醒"权限
2. **电池优化**：将应用添加到电池优化白名单
3. **自启动管理**：允许应用自启动（某些手机需要）

## 安装说明

1. 下载APK文件到Android设备
2. 在设置中启用"未知来源"安装
3. 安装APK文件
4. 首次运行时授予必要权限
5. 在电池设置中将应用加入白名单

## 注意事项

- APK文件大小约为2-5MB
- 支持Android 5.0+（API 21+）
- 需要网络权限（用于音效生成）
- 自动防锁屏，无需手动设置

## 故障排除

### 如果应用仍然锁屏：
1. 检查应用权限设置
2. 关闭电池优化
3. 在开发者选项中启用"保持唤醒"
4. 重启应用

### 如果音效不工作：
1. 检查音量设置
2. 确保应用有音频权限
3. 尝试点击屏幕激活音频上下文

## 联系支持

如果遇到问题，可以：
1. 检查浏览器控制台错误信息
2. 确认设备兼容性
3. 尝试重新安装应用

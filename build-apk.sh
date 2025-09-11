#!/bin/bash

echo "🚀 开始构建Android APK..."

# 检查并安装依赖
install_dependencies() {
    echo "📦 检查依赖..."
    
    # 安装Node.js
    if ! command -v node &> /dev/null; then
        echo "安装Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
    
    # 安装Java (Android构建需要)
    if ! command -v java &> /dev/null; then
        echo "安装Java..."
        sudo apt-get update
        sudo apt-get install -y openjdk-11-jdk
    fi
    
    # 安装Android SDK
    if [ ! -d "$HOME/android-sdk" ]; then
        echo "安装Android SDK..."
        cd $HOME
        wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip
        unzip commandlinetools-linux-8512546_latest.zip
        mkdir -p android-sdk/cmdline-tools
        mv cmdline-tools android-sdk/cmdline-tools/latest
        rm commandlinetools-linux-8512546_latest.zip
        
        export ANDROID_HOME=$HOME/android-sdk
        export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
        
        # 接受许可并安装必要组件
        yes | sdkmanager --licenses
        sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"
    fi
    
    # 设置环境变量
    export ANDROID_HOME=$HOME/android-sdk
    export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
    
    # 安装Cordova
    if ! command -v cordova &> /dev/null; then
        echo "安装Cordova..."
        npm install -g cordova
    fi
}

# 创建Cordova项目
create_cordova_project() {
    echo "📱 创建Cordova项目..."
    
    # 清理旧项目
    rm -rf light-app
    
    # 创建新项目
    cordova create light-app com.luvglow.app "LuvGlow"
    cd light-app
    
    # 添加Android平台
    cordova platform add android
    
    # 安装插件
    cordova plugin add cordova-plugin-insomnia
    cordova plugin add cordova-plugin-whitelist
    cordova plugin add cordova-plugin-device
}

# 配置项目
configure_project() {
    echo "⚙️ 配置项目..."
    
    # 创建config.xml
    cat > config.xml << 'EOF'
<?xml version='1.0' encoding='utf-8'?>
<widget id="com.luvglow.app" version="1.0.0" xmlns="http://www.w3.org/ns/widgets" xmlns:cdv="http://cordova.apache.org/ns/1.0">
    <name>LuvGlow</name>
    <description>LuvGlow 爱爱氛围灯</description>
    <author email="dev@luvglow.com" href="https://wangyouwei2016.github.io/light/">LuvGlow Team</author>
    <content src="index.html" />
    <access origin="*" />
    <allow-intent href="http://*/*" />
    <allow-intent href="https://*/*" />
    <allow-intent href="tel:*" />
    <allow-intent href="sms:*" />
    <allow-intent href="mailto:*" />
    <allow-intent href="geo:*" />
    
    <platform name="android">
        <allow-intent href="market:*" />
        <preference name="Orientation" value="portrait" />
        <preference name="KeepRunning" value="true" />
        <preference name="ShowSplashScreenSpinner" value="false" />
        <preference name="SplashScreenDelay" value="0" />
        <preference name="AutoHideSplashScreen" value="true" />
        <preference name="android-minSdkVersion" value="22" />
        <preference name="android-targetSdkVersion" value="33" />
        <preference name="android-compileSdkVersion" value="33" />
    </platform>
    
    <preference name="DisallowOverscroll" value="true" />
    <preference name="Fullscreen" value="true" />
    
    <!-- 防止锁屏 -->
    <plugin name="cordova-plugin-insomnia" spec="^4.3.0" />
    <plugin name="cordova-plugin-whitelist" spec="^1.3.4" />
    <plugin name="cordova-plugin-device" spec="^2.1.0" />
</widget>
EOF

    # 复制并修改HTML文件
    cp ../android-index.html www/index.html
    
    # 创建图标和启动画面
    mkdir -p res/icon/android
    mkdir -p res/screen/android
}

# 构建APK
build_apk() {
    echo "🔨 构建APK..."
    
    # 构建调试版本
    cordova build android --debug
    
    if [ $? -eq 0 ]; then
        echo "✅ APK构建成功！"
        echo "📍 APK位置: $(pwd)/platforms/android/app/build/outputs/apk/debug/app-debug.apk"
        
        # 复制APK到项目根目录
        cp platforms/android/app/build/outputs/apk/debug/app-debug.apk ../LuvGlow.apk
        echo "📱 APK已复制到: $(dirname $(pwd))/LuvGlow.apk"
        
        # 显示APK信息
        ls -lh ../LuvGlow.apk
    else
        echo "❌ APK构建失败"
        exit 1
    fi
}

# 主函数
main() {
    cd /home/ec2-user/light
    
    install_dependencies
    create_cordova_project
    configure_project
    build_apk
    
    echo ""
    echo "🎉 构建完成！"
    echo "📱 APK文件: /home/ec2-user/light/LuvGlow.apk"
    echo ""
    echo "📋 安装说明："
    echo "1. 将APK文件传输到Android设备"
    echo "2. 在设备上启用'未知来源'安装"
    echo "3. 安装APK文件"
    echo "4. 应用会自动防止锁屏"
}

# 运行主函数
main

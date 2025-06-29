#!/bin/bash
# Deployment script untuk HIMA MI Application

echo "🚀 HIMA MI Deployment Script"
echo "================================"

# Check if CATALINA_HOME is set
if [ -z "$CATALINA_HOME" ]; then
    echo "❌ Error: CATALINA_HOME not set"
    echo "Please set CATALINA_HOME environment variable"
    exit 1
fi

# Create directories
echo "📁 Creating directories..."
mkdir -p compiled-classes
mkdir -p himami-war/WEB-INF/classes

# Compile Java files
echo "🔄 Compiling Java files..."
javac -cp "$CATALINA_HOME/lib/servlet-api.jar" -d compiled-classes \
    src/main/java/com/himami/model/*.java \
    src/main/java/com/himami/storage/*.java \
    src/main/java/com/himami/util/*.java \
    src/main/java/com/himami/servlet/*.java \
    src/main/java/com/himami/filter/*.java

if [ $? -ne 0 ]; then
    echo "❌ Compilation failed!"
    exit 1
fi

echo "✅ Compilation successful!"

# Copy webapp files
echo "📋 Copying webapp files..."
cp -r src/main/webapp/* himami-war/

# Copy compiled classes
echo "📦 Copying compiled classes..."
cp -r compiled-classes/com himami-war/WEB-INF/classes/

# Create WAR file
echo "🗜️ Creating WAR file..."
cd himami-war
jar -cvf ../himami.war *
cd ..

# Deploy to Tomcat
echo "🚀 Deploying to Tomcat..."
cp himami.war "$CATALINA_HOME/webapps/"

# Clean up
echo "🧹 Cleaning up..."
rm -rf compiled-classes
rm -rf himami-war
rm himami.war

echo ""
echo "✅ Deployment completed successfully!"
echo "🌐 Access your application at: http://localhost:8080/himami/"
echo ""
echo "📝 Next steps:"
echo "1. Start Tomcat: $CATALINA_HOME/bin/startup.sh"
echo "2. Check logs: tail -f $CATALINA_HOME/logs/catalina.out"
echo "3. Access application in browser"

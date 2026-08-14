FROM plugfox/flutter:3.44.5-android

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./

RUN flutter pub get

COPY . .

RUN flutter doctor -v

RUN flutter build apk --release
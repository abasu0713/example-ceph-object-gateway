
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.12)
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY lib/* ./lib/
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN mkdir -p bin
RUN dart compile exe lib/main.dart -o bin/dart-ceph-object-gateway

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/dart-ceph-object-gateway /app/bin/

ENTRYPOINT ["/app/bin/dart-ceph-object-gateway"]
CMD []

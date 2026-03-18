## Qt6/C++ приложение

**Qt** — это кросс‑платформенный фреймворк для разработки программного обеспечения на языке **C++**.

### 1. Структура проекта
```
qt6-docker-app/
├── CMakeLists.txt          # Скрипт сборки для CMake
├── main.cpp                # Исходный код приложения
└── Dockerfile              # Инструкция для создания образа
```

В каталоге для Docker-проектов создать одной bash-командой всю структуру для нового приложения:
```shell
mkdir -p qt6-docker-app && touch qt6-docker-app/Dockerfile qt6-docker-app/main.cpp qt6-docker-app/CMakeLists.txt && cd qt6-docker-app
```

### 2. Содержимое файла `Dockerfile`
```dockerfile
# Используем последнюю LTS-версию Ubuntu
FROM ubuntu:22.04

# Отключаем интерактивные диалоги при установке пакетов
ENV DEBIAN_FRONTEND=noninteractive

# Устанавливаем зависимости:
# - build-essential, cmake, ninja-build: инструменты сборки
# - qt6-base-dev: заголовочные файлы и библиотеки Qt6 [citation:1][citation:5]
# - libgl1-mesa-dev, libxcb-*-dev: зависимости для работы графики и OpenGL
# - mesa-utils: полезно для диагностики (glxgears)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    ninja-build \
    qt6-base-dev \
    libgl1-mesa-dev \
    libxcb-xinerama0-dev \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxcb-render-util0-dev \
    libxcb-shape0-dev \
    libxcb-sync-dev \
    libxcb-xfixes0-dev \
    libxcb-xkb-dev \
    libxkbcommon-x11-dev \
    mesa-utils \
    && rm -rf /var/lib/apt/lists/*

# Создаём рабочую директорию
WORKDIR /app

# Копируем исходный код и скрипт сборки
COPY CMakeLists.txt main.cpp ./

# Собираем приложение в отдельной папке build
RUN cmake -B build -S . -G Ninja && \
    cmake --build build --parallel

# Указываем платформу для отрисовки (xcb для X11) [citation:1]
ENV QT_QPA_PLATFORM=xcb

# Приложение будет лежать в /app/build/qt6_app
CMD ["./build/qt6_app"]
```

### Dockerfile v2
```dockerfile
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Устанавливаем всё необходимое для сборки и запуска Qt6 GUI
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    ninja-build \
    qt6-base-dev \
    qt6-base-dev-tools \
    libgl1-mesa-dev \
    libxkbcommon-x11-0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-shape0 \
    libxcb-shm0 \
    libxcb-sync1 \
    libxcb-xfixes0 \
    libxcb-xinerama0 \
    libxcb-cursor0 \
    libxcb-xkb1 \
    libxcb-util1 \
    libxkbcommon0 \
    libxkbcommon-x11-0 \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxcb-render-util0-dev \
    libxcb-shape0-dev \
    libxcb-xfixes0-dev \
    libxcb-xinerama0-dev \
    libxcb-cursor-dev \
    libxcb-xkb-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    mesa-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY CMakeLists.txt main.cpp ./

RUN cmake -B build -S . -G Ninja && \
    cmake --build build --parallel

ENV QT_QPA_PLATFORM=xcb

CMD ["./build/qt6_app"]
```

### 3. Содержимое файла `CMakeLists.txt`
```cmake
cmake_minimum_required(VERSION 3.16)
project(Qt6DockerApp)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Widgets)

add_executable(qt6_app main.cpp)
target_link_libraries(qt6_app Qt6::Core Qt6::Widgets)
```

### 4. Содержимое файла `main.cpp` (простое Qt-приложение)
```cpp
#include <QApplication>
#include <QLabel>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QLabel label("Привет из Docker-контейнера с Qt6! 🐳");
    label.show();
    return app.exec();
}
```

### 5. Сборка и запуск

В командной строке, находясь в папке `qt6-docker-app`, выполнить:
```shell
docker build -t qt6-app .
```

Создание и запуск контейнера для **Linux/WSL**
```shell
xhost +local:docker
```
```shell
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  qt6-app
```

Создание и запуск контейнера для **Windows/WSLg**

В терминале Ubuntu (Ubuntu можно вызвать из Главного меню Windows) выполнить:
```shell
docker run -it --rm \
  -e DISPLAY=host.docker.internal:0 \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  qt6-app
```
или в Power Shell:
```shell
docker run -it --rm `
  -e DISPLAY=:0 `
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw `
  qt6-app
```

Создание и запуск контейнера для **macOS**
```shell
xhost + 127.0.0.1
```
и
```shell
docker run -it --rm \
  -e DISPLAY=host.docker.internal:0 \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  qt6-app
```


if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await DesktopWindow.setMaxWindowSize(const Size(400, 450));
    await DesktopWindow.setMaxWindowSize(const Size(400, 450));
    await DesktopWindow.setWindowSize(const Size(400, 450));
  }
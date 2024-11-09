class IOSDeviceMap {
  static const Map<String, String> models = {
    'iPhone15,3': 'iPhone 14 Pro Max',
    'iPhone16,2': 'iPhone 15 Pro Max',
    // 可以添加更多型号映射
  };

  static String getModelName(String identifier) {
    return models[identifier] ?? identifier;
  }
}

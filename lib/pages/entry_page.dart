import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/cupertino.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage>
    with SingleTickerProviderStateMixin {
  // 控制器
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _batteryController = TextEditingController();

  // 版本选择相关
  String _selectedNetwork = '全网通';
  String _selectedCountry = '国行';
  String _selectedWarranty = '有保';

  // 员工选择相关
  final List<String> _staffList = ['张三', '李四', '王五', '赵六', '孙七', '周八'];
  int _selectedStaffIndex = 0;
  String? _selectedStaff;

  // 添加 ExpansionTile 的 key
  final GlobalKey<ExpansionTileCardState> networkKey = GlobalKey();
  final GlobalKey<ExpansionTileCardState> countryKey = GlobalKey();
  final GlobalKey<ExpansionTileCardState> warrantyKey = GlobalKey();

  // 添加动画控制器
  late AnimationController _animationController;

  int? _tempSelectedStaffIndex;

  // 添加动画控制器映射
  final Map<GlobalKey<ExpansionTileCardState>, bool> _isExpandedMap = {};

  void _showStaffPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // 顶部标题栏
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        '取消',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Text(
                      '选择员工',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_tempSelectedStaffIndex != null) {
                          setState(() {
                            _selectedStaffIndex = _tempSelectedStaffIndex!;
                            _selectedStaff = _staffList[_selectedStaffIndex];
                          });
                        }
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '确定',
                        style: TextStyle(
                          color: Color(0xFF26263A),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 滚动选择器
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 44,
                  scrollController: FixedExtentScrollController(
                    initialItem: _selectedStaffIndex,
                  ),
                  onSelectedItemChanged: (int index) {
                    _tempSelectedStaffIndex = index;
                  },
                  children: _staffList.map((staff) {
                    return Center(
                      child: Text(
                        staff,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击空白处收起键盘
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF26263A), Color(0xFF1F1F1F)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildDeviceInfoCard(),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchField(),
                          const SizedBox(height: 12),
                          _buildSerialField(),
                          const SizedBox(height: 12),
                          _buildNetworkSection(),
                          const SizedBox(height: 12),
                          _buildCountrySection(),
                          const SizedBox(height: 12),
                          _buildWarrantySection(),
                          const SizedBox(height: 12),
                          _buildBatterySection(),
                          const SizedBox(height: 12),
                          _buildStaffSection(),
                          const SizedBox(height: 12),
                          _buildQualitySection(),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildStartButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 搜索字段（使用 TypeAheadField 实现自动完成）
  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: _modelController,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1F1F1F),
          ),
          decoration: InputDecoration(
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 16),
                const Text(
                  '型号',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 100),
            hintText: '请搜索并确认型号全称',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            // 添加清除按钮
            suffixIcon: _modelController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _modelController.clear();
                      });
                    },
                    child: Icon(
                      Icons.cancel,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  )
                : null,
          ),
        ),
        suggestionsCallback: (pattern) async {
          // 这里可以替换为实际的API调用
          return [
            'iPhone 14',
            'iPhone 14 Plus',
            'iPhone 14 Pro',
            'iPhone 14 Pro Max',
            'iPhone 13',
            'iPhone 13 Pro',
            'iPhone 13 Pro Max',
          ]
              .where(
                  (item) => item.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        },
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          borderRadius: BorderRadius.circular(16),
          elevation: 4,
          color: Colors.white,
          constraints: const BoxConstraints(maxHeight: 200),
        ),
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        itemBuilder: (context, suggestion) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              suggestion.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F1F1F),
              ),
            ),
          );
        },
        onSuggestionSelected: (suggestion) {
          _modelController.text = suggestion.toString();
        },
        hideOnEmpty: true,
        hideOnLoading: true,
        hideSuggestionsOnKeyboardHide: false,
        keepSuggestionsOnLoading: false,
        animationDuration: const Duration(milliseconds: 300),
        direction: AxisDirection.down,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // 延迟执行入场动画
    Future.delayed(const Duration(milliseconds: 100), () {
      _animationController.forward();
    });
    _modelController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _modelController.dispose();
    _serialController.dispose();
    _batteryController.dispose();
    _isExpandedMap.clear();
    super.dispose();
  }

  // 网络版本部分
  Widget _buildNetworkSection() {
    return _buildExpansionSection(
      key: networkKey,
      title: '网络版本',
      selectedValue: _selectedNetwork,
      options: ['全网通', '移动版', '电信版'],
      onSelected: (value) => setState(() => _selectedNetwork = value),
    );
  }

  // 国家版本部分
  Widget _buildCountrySection() {
    return _buildExpansionSection(
      key: countryKey,
      title: '国家版本',
      selectedValue: _selectedCountry,
      options: ['国行', '港行', '美版'],
      onSelected: (value) => setState(() => _selectedCountry = value),
    );
  }

  // 保修状态部分
  Widget _buildWarrantySection() {
    return _buildExpansionSection(
      key: warrantyKey,
      title: '保修状态',
      selectedValue: _selectedWarranty,
      options: ['有保', '过保'],
      onSelected: (value) => setState(() => _selectedWarranty = value),
    );
  }

  // 电池效率部分
  Widget _buildBatterySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text(
            '电池效率',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F1F1F),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _batteryController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F1F1F),
              ),
              decoration: InputDecoration(
                hintText: '请输入 %',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 员工选择部分
  Widget _buildStaffSection() {
    return GestureDetector(
      onTap: _showStaffPicker,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Text(
              '采购员工',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F1F1F),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _selectedStaff ?? '请选择',
                style: TextStyle(
                  color: _selectedStaff != null
                      ? const Color(0xFF1F1F1F)
                      : Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // 功能质检部分
  Widget _buildQualitySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text(
            '功能质检',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F1F1F),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '金克斯',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 开始检测按钮
  Widget _buildStartButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // TODO: 实现检测逻辑
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF26263A),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          '开始检测',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // 头部构建
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const BackButton(color: Colors.white),
          const Text(
            '博森科技',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '官方质检',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 设备信息卡片
  Widget _buildDeviceInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'iPhone 14 Pro Max',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Text(
                '内存：',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              Text(
                '4G+256G',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              SizedBox(width: 16),
              Text(
                '串码：',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              Text(
                '456789123456789',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 串码输入字段
  Widget _buildSerialField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text(
            '串码',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F1F1F),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _serialController,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F1F1F),
              ),
              decoration: InputDecoration(
                hintText: '请输入串码',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 优化折叠面板的通用构建方法
  Widget _buildExpansionSection({
    required GlobalKey<ExpansionTileCardState> key,
    required String title,
    required String selectedValue,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    // 确保 key 在 map 中有对应的值
    _isExpandedMap[key] ??= false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ExpansionTileCard(
        key: key,
        baseColor: Colors.white,
        expandedColor: Colors.white.withOpacity(0.95),
        elevation: 0,
        initialElevation: 0,
        borderRadius: BorderRadius.circular(16),
        duration: const Duration(milliseconds: 200),
        shadowColor: Colors.black12,
        trailing: AnimatedRotation(
          duration: const Duration(milliseconds: 200),
          turns: _isExpandedMap[key]! ? 0.5 : 0,
          child: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey[600],
          ),
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpandedMap[key] = expanded;
          });
        },
        title: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F1F1F),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              selectedValue,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ],
        ),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: options.map((option) {
                final isSelected = selectedValue == option;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      onSelected(option);
                      key.currentState?.collapse();
                      setState(() {
                        _isExpandedMap[key] = false; // 更新箭头状态
                      });
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF26263A)
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color:
                                      const Color(0xFF26263A).withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1F1F1F),
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

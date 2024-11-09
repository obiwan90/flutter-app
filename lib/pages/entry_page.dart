import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  // 控制器
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _batteryController = TextEditingController();
  Timer? _debounceTimer;

  // 搜索相关
  List<String> _searchResults = [];
  bool _isSearching = false;

  // 版本选择相关
  bool _isNetworkExpanded = false;
  bool _isCountryExpanded = false;
  String _selectedNetwork = '全网通';
  String _selectedCountry = '国行';
  String _selectedWarranty = '有保';

  // 员工选择相关
  final List<String> _staffList = ['张三', '李四', '王五', '赵六', '孙七', '周八'];
  int _selectedStaffIndex = 0;
  String? _selectedStaff;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _serialController.dispose();
    _batteryController.dispose();
    super.dispose();
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'iPhone 14 Pro Max',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F1F1F),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '内存：4G+256G    串码：456789123456789',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF1F1F1F),
            ),
          ),
        ],
      ),
    );
  }

  // 搜索字段
  Widget _buildSearchField() {
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
            '型号',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F1F1F),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '请搜索并确认型号全称',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 通用版本选择部分
  Widget _buildVersionSection(
    String title,
    List<String> options,
    bool isExpanded,
    Function(bool) onExpanded,
    String selectedValue,
    Function(String) onSelected,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => onExpanded(!isExpanded),
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
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
                  Expanded(
                    child: Text(
                      selectedValue,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[400],
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(80, 0, 16, 16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: options.map((option) {
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                      onExpanded(false);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selectedValue == option
                            ? const Color(0xFF26263A)
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: selectedValue == option
                              ? Colors.white
                              : const Color(0xFF1F1F1F),
                          fontSize: 14,
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

  // 网络版本部分
  Widget _buildNetworkSection() {
    return _buildVersionSection(
      '网络版本',
      ['全网通', '移动版', '电信版'],
      _isNetworkExpanded,
      (expanded) => setState(() => _isNetworkExpanded = expanded),
      _selectedNetwork,
      (selected) => setState(() => _selectedNetwork = selected),
    );
  }

  // 国家版本部分
  Widget _buildCountrySection() {
    return _buildVersionSection(
      '国家版本',
      ['国行', '港行', '美版'],
      _isCountryExpanded,
      (expanded) => setState(() => _isCountryExpanded = expanded),
      _selectedCountry,
      (selected) => setState(() => _selectedCountry = selected),
    );
  }

  // 保修状态部分
  Widget _buildWarrantySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                '保修状态',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Wrap(
                  spacing: 12,
                  children: ['有保', '过保'].map((option) {
                    return GestureDetector(
                      onTap: () => setState(() => _selectedWarranty = option),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedWarranty == option
                              ? const Color(0xFF26263A)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          option,
                          style: TextStyle(
                            color: _selectedWarranty == option
                                ? Colors.white
                                : const Color(0xFF1F1F1F),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
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
              decoration: InputDecoration(
                hintText: '请输入 %',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                border: InputBorder.none,
                suffixText: '%',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 员工选择部分
  Widget _buildStaffSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: _showStaffPicker,
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

  // 员工选择弹窗
  void _showStaffPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
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
                    '选择采购员工',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedStaff = _staffList[_selectedStaffIndex];
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(
                      '确定',
                      style: TextStyle(
                        color: Color(0xFF26263A),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 44,
                onSelectedItemChanged: (index) {
                  setState(() => _selectedStaffIndex = index);
                },
                children: _staffList.map((staff) {
                  return Center(
                    child: Text(
                      staff,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        child: const Text(
          '开始检测',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

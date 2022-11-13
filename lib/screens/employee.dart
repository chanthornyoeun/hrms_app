import 'package:flutter/material.dart';
import 'package:hrms_app/core/debounce_time.dart';
import 'package:hrms_app/models/employee.dart';
import 'package:hrms_app/models/response_dto.dart';
import 'package:hrms_app/services/employee_service.dart';
import 'package:hrms_app/widgets/avatar.dart';
import 'package:loading_overlay/loading_overlay.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final EmployeeService _employeeService = EmployeeService();
  final List<Employee> _employees = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final DebounceTime _debounceTime = DebounceTime(milliseconds: 500);

  bool _clearOnce = true;
  bool _isLoading = false;
  int _total = 0;
  final int _limit = 20;
  int _offset = 0;

  @override
  void initState() {
    super.initState();
    _getEmployees({'offset': _offset, 'limit': _limit}, false);
    _handleInfiniteScroll();
  }

  void _handleInfiniteScroll() {
    _scrollController.addListener(() {
      final currentPosition = _scrollController.position.pixels;
      final fetchMore = _scrollController.position.maxScrollExtent;
      if (currentPosition >= fetchMore && _total > _offset) {
        _getEmployees({
          'offset': _offset,
          'limit': _limit,
          'search': _searchController.text
        }, false);
      }
    });
  }

  Future<void> _pullRefresh() async {
    _offset = 0;
    _getEmployees({
      'offset': _offset,
      'limit': _limit,
    }, true);
  }

  void _getEmployees(Map<String, dynamic> params, bool clear) async {
    setState(() {
      _isLoading = true;
    });
    ResponseDTO res = await _employeeService.list(param: params);
    if (clear) {
      _employees.clear();
    }
    setState(() {
      for (var employee in res.data) {
        _employees.add(Employee.fromJson(employee));
      }
      _total = res.total;
      _offset = _offset + _limit;
      _isLoading = false;
    });
  }

  void _search(String query) {
    _offset = 0;
    _clearOnce = query.isEmpty || query == '';
    _getEmployees({'offset': _offset, 'limit': _limit, 'search': query}, true);
  }

  void _clearHandler() {
    if (_clearOnce) return;
    _searchController.text = '';
    _search(_searchController.text);
    _clearOnce = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
      ),
      body: LoadingOverlay(
          isLoading: _isLoading,
          opacity: 0.1,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _searchController,
                      onChanged: (value) =>
                          _debounceTime.run(() => _search(value)),
                      decoration: InputDecoration(
                        hintText:
                            "Search by name, position, department and phone",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearHandler,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(10),
                    children: _generateEmployeeCard(_employees),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  List<Card> _generateEmployeeCard(List<Employee> employees) {
    List<Card> cards = [];
    for (Employee employee in employees) {
      final Card card = Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Avatar(
                picture: employee.profilePhoto,
                gender: employee.gender,
                padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    employee.position ?? 'No position',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(employee.department ?? 'No department',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal)),
                  const SizedBox(height: 6),
                  Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.phone),
                      Text(employee.phone ?? ''),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      cards.add(card);
    }
    return cards;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _searchController.dispose();
  }
}

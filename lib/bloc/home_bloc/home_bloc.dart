import 'package:quan_ly_chi_tieu/bloc/analytic_bloc/analytic_state.dart';
import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_event.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_state.dart';
import 'package:quan_ly_chi_tieu/core/local/database/expense_management_db.dart';
import 'package:quan_ly_chi_tieu/core/local/global_db.dart';
import 'package:quan_ly_chi_tieu/resource/enum.dart';

class HomeBloc extends BaseBloc {
  String balanceAmount = '';
  String transitionName = '';
  String amountEntered = '';
  String spendingLimit = '';
  List<CategoryTransactionData> listCategoryTransaction = [];
  HomeBloc() {
    double balanceParseDouble = 0.0;

    ///enter amount
    on<EnterValueEvent>((event, emit) => {
          amountEntered += event.value,
          emit(EnterValueState(amountEntered)),
        });

    on<BlackSpaceEvent>((event, emit) => {
          if (amountEntered.isNotEmpty)
            {
              amountEntered =
                  amountEntered.substring(0, amountEntered.length - 1),
              emit(EnterValueState(amountEntered)),
            }
        });

    on<ClearAmountEnteredEvent>((event, emit) => {
          amountEntered = '',
          transitionName = '',
          emit(EnterValueState(amountEntered)),
          emit(EnterTransactionNameState(transitionName)),
        });

    ///enter transaction name
    on<EnterTransactionNameEvent>((event, emit) => {
          transitionName = event.value,
          emit(EnterTransactionNameState(transitionName)),
        });
    on<QuickSelectTransactionNameEvent>((event, emit) => {
          transitionName = '',
          transitionName = event.value,
          emit(QuickSelectTransactionNameState(transitionName)),
        });

    ///Save transaction
    on<SaveTransactionEvent>((event, emit) async => {
          balanceParseDouble =
              balanceAmount.isNotEmpty ? double.parse(balanceAmount) : 0.0,
          if (amountEntered.isNotEmpty && transitionName.isNotEmpty)
            {
              await database.createTransaction(
                TransactionsHistoryCompanion.insert(
                    name: transitionName,
                    type: TransactionType.expense.toString(),
                    amount: double.parse(amountEntered)),
              ),
              await database.createOrUpdateBalance(
                BalanceData(
                  id: 1,
                  dateCreated: DateTime.now(),
                  amount: balanceParseDouble - double.parse(amountEntered),
                ),
              ),
              balanceAmount =
                  (balanceParseDouble - double.parse(amountEntered)).toString(),
              amountEntered = '',
              transitionName = '',
              emit(GetBalanceState()),
              emit(SaveTransactionState()),
              emit(EnterValueState(amountEntered)),
              emit(EnterTransactionNameState(transitionName)),
              emit(GetTransactionHistoryState())
            },
        });

    ///get balance
    on<GetBalanceEvent>((event, emit) => {
          database.getBalance().then(
                (value) => balanceAmount = value.amount.toString(),
              ),
          emit(GetBalanceState()),
        });

    double totalIncrement = 0.0;
    on<IncrementBalanceEvent>((event, emit) async => {
          balanceParseDouble =
              balanceAmount.isNotEmpty ? double.parse(balanceAmount) : 0.0,
          if (amountEntered.isNotEmpty)
            {
              totalIncrement =
                  balanceParseDouble += double.parse(amountEntered),
              balanceAmount = totalIncrement.toString(),
              await database.createTransaction(
                TransactionsHistoryCompanion.insert(
                    name: transitionName,
                    type: TransactionType.income.toString(),
                    amount: double.parse(amountEntered)),
              ),
              await database.createOrUpdateBalance(
                BalanceData(
                  id: 1,
                  dateCreated: DateTime.now(),
                  amount: totalIncrement,
                ),
              ),
              amountEntered = '',
              transitionName = '',
              emit(GetBalanceState()),
              emit(SaveTransactionState()),
              emit(EnterValueState(amountEntered)),
              emit(EnterTransactionNameState(transitionName)),
              emit(GetTransactionHistoryState())
            }
        });

    on<SaveSpendingLimitEvent>((event, emit) async => {
          await database.createOrUpdateSpendingLimit(
            SpendingLimitData(
              id: 1,
              amount: event.amount,
              dateCreated: event.startDate,
              dateCreatedUntil: event.endDate,
            ),
          ),
          add(GetSpendingLimitEvent()),
          emit(SaveSpendingLimitState(event.amount)),
        });

    on<GetSpendingLimitEvent>((event, emit) async => {
          await database.getSpendingLimit().then(
                (value) => spendingLimit =
                    value.amount > 0 ? value.amount.toString() : '',
              ),
          emit(GetSpendingLimitState(spendingLimit)),
        });

    on<GetListCategoryTransaction>((evenr, emit) async => {
          listCategoryTransaction.clear(),
          await database
              .getCategory()
              .then((value) => listCategoryTransaction.addAll(value)),
          emit(GetListCategoryTransactionState()),
        });

    on<SaveCategoryTransactionEvent>((event, emit) {
      database.addCategory(CategoryTransactionCompanion.insert(
        name: event.name,
        type: event.type.toString(),
      ));
      add(GetListCategoryTransaction());
    });

    on<SelectTypeOfCategoryEvent>((event, emit) {
      emit(SelectTypeOfCategoryState(event.type));
    });

    on<DeleteCategoryTransactionEvent>((event, emit) {
      database.deleteCategory(event.id);
      add(GetListCategoryTransaction());
    });
  }
}

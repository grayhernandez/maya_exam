# Send Money App

A Flutter mobile application built as a take-home exam. Users can log in, view their wallet balance, send money via a REST API, and review their transaction history.

> **Stack:** Flutter • Clean Architecture • Cubit State Management • JSONPlaceholder API

---

## Screens

| # | Screen | Description |
|---|--------|-------------|
| 1 | **Login** | Username & password authentication |
| 2 | **Home / Dashboard** | Wallet balance with show/hide toggle, Send Money & View Transactions buttons |
| 3 | **Send Money** | Numeric input, Submit button, Success/Error bottom sheet |
| 4 | **Transaction History** | List of all transactions fetched from the API |

**Demo credentials:**
```
admin     / password123
user      / user123
test      / password
```

---

## How to Run

### Prerequisites
- Flutter SDK `>= 3.0.0`
- Dart SDK `>= 3.0.0`
- A connected device or emulator

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/grayhernandez/maya_exam.git
cd maya_app

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

---

## How to Run Unit Tests

```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/login_cubit_test.dart
flutter test test/home_cubit_test.dart
flutter test test/send_money_cubit_test.dart

# Run with verbose output
flutter test --reporter expanded

# Run with coverage
flutter test --coverage
```

---

## Unit Test Cases

### `login_cubit_test.dart`
| Test                                      | Expected |
|-------------------------------------------|----------|
| Initial state is false (not logged in)    | `false` |
| Login with valid credentials              | emits `true` |
| Logout resets state                       | emits `false` |

### `home_cubit_test.dart`
| Test                                      | Expected |
|-------------------------------------------|-----------------------------------|
| Initial balance is 500.00                 | `state.balance == 500.00` |
| `updateBalance(100)` deducts correctly    | `state.balance == 400.00` |
| Toggle visibility hides balance           | `state.isBalanceVisible == false` |
| Toggle visibility again restores it       | `state.isBalanceVisible == true` |

### `send_money_cubit_test.dart`
| Test                                          | Expected |
|-----------------------------------------------|----------|
| Initial state is `SendStatus.initial`         | `SendStatus.initial` |
| Send valid amount (100)                       | emits `loading` → `success` |
| Send invalid amount (-50)                     | emits `error` |

---

## Project Structure

```
maya_app/
├── lib/
│   ├── main.dart                          # Entry point, global BlocProvider
│   ├── core/
│   │   └── network/
│   │       └── api_client.dart            # HTTP client (GET / POST)
│   ├── domain/
│   │   ├── entities/
│   │   │   └── transaction.dart           # Pure Transaction entity
│   │   ├── repositories/
│   │   │   └── transaction_repository.dart  # Abstract interface
│   │   └── usecases/
│   │       ├── get_transactions_usecase.dart
│   │       └── send_money_usecase.dart
│   ├── data/
│   │   └── repositories/
│   │       └── transaction_repository_impl.dart  # API implementation
│   └── presentation/
│       ├── login/
│       │   ├── login_cubit.dart           # State: bool
│       │   └── login_screen.dart
│       ├── home/
│       │   ├── home_cubit.dart            # State: HomeState
│       │   └── home_screen.dart
│       ├── send_money/
│       │   ├── send_money_cubit.dart      # State: SendStatus enum
│       │   └── send_money_screen.dart
│       └── transactions/
│           ├── transaction_cubit.dart     # State: TransactionState
│           └── transaction_screen.dart
└── test/
    ├── home_cubit_test.dart
    ├── login_cubit_test.dart
    └── send_money_cubit_test.dart
```

---

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_bloc` | ^8.1.3 | Cubit / BLoC state management |
| `equatable` | ^2.0.5 | Value equality for state objects |
| `http` | ^1.1.0 | HTTP calls to JSONPlaceholder |
| `bloc_test` | ^9.1.5 | Cubit unit testing helpers |
| `mocktail` | ^1.0.1 | Mocking in tests |

---

## API

Uses [JSONPlaceholder](https://jsonplaceholder.typicode.com/) as a fake REST API.

| Action | Method | Endpoint |
|--------|--------|----------|
| Fetch transactions | `GET` | `/posts?userId=1&_limit=10` |
| Send money | `POST` | `/posts` |

---

## Architecture

The app follows **Clean Architecture** with three layers that depend strictly inward.

```
Presentation  ──►  Domain  ◄──  Data
 (Cubits/UI)     (Entities,    (API, Repository
                  Use Cases,    Implementation)
                  Interfaces)
```

- **Domain** — Pure Dart. No Flutter dependencies. Owns all business rules.
- **Data** — Implements domain interfaces. Handles HTTP via `ApiClient`.
- **Presentation** — Flutter widgets + Cubits. Subscribes to state, renders UI.

### State Management (Cubit)

| Cubit                 | State Type            | Notes |
|-----------------------|-----------------------|-------|
| `LoginCubit`          | `bool`                | `true` = logged in |
| `HomeCubit`           | `HomeState`           | Holds `balance` + `isBalanceVisible` together to avoid BLoC's same-value-emit bug |
| `SendMoneyCubit`      | `SendStatus`          | Enum: `initial → loading → success / error` |
| `TransactionCubit`    | `TransactionState`    | Sealed: `Initial / Loading / Loaded / Error` |

---

## Class Diagram

```
┌─────────────────────────────────────────────────┐
│                  DOMAIN LAYER                   │
│                                                 │
│  Transaction                                    │
│  ├── id: int                                    │
│  ├── amount: double                             │
│  ├── title: String                              │
│  └── date: DateTime                             │
│                                                 │
│  <<abstract>> TransactionRepository             │
│  ├── getTransactions(): List<Transaction>       │
│  └── sendMoney(amount): Transaction             │
│                                                 │
│  GetTransactionsUseCase                         │
│  └── call(): List<Transaction>                  │
│                                                 │
│  SendMoneyUseCase                               │
│  └── call(amount): Transaction                  │
└─────────────────────────────────────────────────┘
                        ▲ implements
┌─────────────────────────────────────────────────┐
│                   DATA LAYER                    │
│                                                 │
│  TransactionRepositoryImpl                      │
│  ├── apiClient: ApiClient                       │
│  ├── getTransactions(): List<Transaction>       │
│  └── sendMoney(amount): Transaction             │
│                                                 │
│  ApiClient                                      │
│  ├── get(path): dynamic                         │
│  └── post(path, body): dynamic                  │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│              PRESENTATION LAYER                 │
│                                                 │
│  LoginCubit<bool>                               │
│  ├── login(username, password)                  │
│  └── logout()                                   │
│                                                 │
│  HomeCubit<HomeState>                           │
│  ├── updateBalance(amount)                      │
│  └── toggleBalanceVisibility()                  │
│                                                 │
│  SendMoneyCubit<SendStatus>                     │
│  ├── sendMoney(amount)                          │
│  └── reset()                                    │
│                                                 │
│  TransactionCubit<TransactionState>             │
│  └── loadTransactions()                         │
└─────────────────────────────────────────────────┘
```

---

## Sequence Diagrams

### Login Flow
```
User         LoginScreen      LoginCubit       HomeScreen
  │               │                │                │
  │── enter ─────►│                │                │
  │   credentials │                │                │
  │               │── login() ────►│                │
  │               │                │── validate ───►│
  │               │                │   credentials  │
  │               │                │◄── emit(true) ─│
  │               │◄── navigate ───│                │
  │               │    to Home     │                │
```

### Send Money Flow
```
User        SendMoneyScreen   SendMoneyCubit      API
  │               │                │               │
  │── enter amt ─►│                │               │
  │               │── sendMoney() ►│               │
  │               │                │── POST /posts►│
  │               │                │◄── 201 ───────│
  │               │◄── emit ───────│               │
  │               │    (success)   │               │
  │◄── show ──────│                │               │
  │    bottom     │                │               │
  │    sheet      │── updateBalance()              │
  │               │   (HomeCubit)  │               │
```

### View Transactions Flow
```
User      TransactionScreen  TransactionCubit      API
  │               │                │               │
  │── tap ───────►│                │               │
  │               │── load() ─────►│               │
  │               │                │── GET /posts ►│
  │               │                │◄── 200 ───────│
  │               │◄── emit ───────│               │
  │               │    (Loaded)    │               │
  │◄── show list ─│                │               │
```
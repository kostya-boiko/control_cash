class Transaction {
  final String title;
  final double amount; // негатив = витрата, позитив = дохід
  final DateTime date;
  final String category;
  final String comment;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.comment,
  });
}

final List<Transaction> transactions = [
  Transaction(
    title: "Groceries",
    amount: -120.50,
    date: DateTime.parse("2025-11-22 10:15"),
    category: "Food",
    comment: "Bought vegetables and fruits",
  ),
  Transaction(
    title: "Uber",
    amount: -85.00,
    date: DateTime.parse("2025-11-22 12:30"),
    category: "Transport",
    comment: "Ride to office",
  ),
  Transaction(
    title: "Coffee",
    amount: -25.75,
    date: DateTime.parse("2025-11-21 09:00"),
    category: "Food",
    comment: "Morning coffee",
  ),
  Transaction(
    title: "Movie Ticket",
    amount: -150.00,
    date: DateTime.parse("2025-11-20 19:00"),
    category: "Fun",
    comment: "Cinema with friends",
  ),
  Transaction(
    title: "Salary",
    amount: 5000.00,
    date: DateTime.parse("2025-11-20 08:00"),
    category: "Income",
    comment: "Monthly salary",
  ),
  Transaction(
    title: "Book",
    amount: -200.00,
    date: DateTime.parse("2025-11-19 16:45"),
    category: "Other",
    comment: "Bought new novel",
  ),
  Transaction(
    title: "Gym Subscription",
    amount: -450.00,
    date: DateTime.parse("2025-11-18 08:00"),
    category: "Health",
    comment: "Monthly subscription",
  ),
  Transaction(
    title: "Restaurant",
    amount: -320.00,
    date: DateTime.parse("2025-11-17 20:00"),
    category: "Food",
    comment: "Dinner with family",
  ),
  Transaction(
    title: "Bus Ticket",
    amount: -15.00,
    date: DateTime.parse("2025-11-16 07:30"),
    category: "Transport",
    comment: "Morning commute",
  ),
  Transaction(
    title: "Concert",
    amount: -600.00,
    date: DateTime.parse("2025-11-15 21:00"),
    category: "Fun",
    comment: "Live music show",
  ),
  Transaction(
    title: "Pharmacy",
    amount: -75.50,
    date: DateTime.parse("2025-11-14 11:15"),
    category: "Health",
    comment: "Bought vitamins",
  ),
  Transaction(
    title: "Taxi",
    amount: -120.00,
    date: DateTime.parse("2025-11-13 23:00"),
    category: "Transport",
    comment: "Late night ride",
  ),
  Transaction(
    title: "Lunch",
    amount: -90.00,
    date: DateTime.parse("2025-11-12 13:00"),
    category: "Food",
    comment: "Quick lunch at cafe",
  ),
  Transaction(
    title: "Online Course",
    amount: -500.00,
    date: DateTime.parse("2025-11-11 18:00"),
    category: "Education",
    comment: "Flutter course",
  ),
  Transaction(
    title: "Snacks",
    amount: -45.25,
    date: DateTime.parse("2025-11-10 15:30"),
    category: "Food",
    comment: "Evening snacks",
  ),
  Transaction(
    title: "Parking",
    amount: -30.00,
    date: DateTime.parse("2025-11-09 17:45"),
    category: "Transport",
    comment: "Paid parking fee",
  ),
  Transaction(
    title: "Haircut",
    amount: -150.00,
    date: DateTime.parse("2025-11-08 14:00"),
    category: "Other",
    comment: "Salon visit",
  ),
  Transaction(
    title: "Electricity Bill",
    amount: -780.00,
    date: DateTime.parse("2025-11-07 09:00"),
    category: "Bills",
    comment: "Monthly electricity payment",
  ),
  Transaction(
    title: "Water",
    amount: -120.00,
    date: DateTime.parse("2025-11-06 10:30"),
    category: "Bills",
    comment: "Water supply bill",
  ),
  Transaction(
    title: "Streaming Service",
    amount: -199.00,
    date: DateTime.parse("2025-11-04 20:15"),
    category: "Entertainment",
    comment: "Monthly subscription",
  ),
];

enum TripStatus { bidding, pending, accepted, running, completed, canceled }

class Trip {
  final String id;
  final String fromLocation;
  final String toLocation;
  final double requestedPrice;
  final DateTime startTime;
  final DateTime biddingEndTime;
  final int participantCount;
  final String? vehicleType;
  final String? notes;
  final TripStatus status;
  final double? bidPrice;
  final String? selectedDriverId;
  final String? selectedVehicleId;
  final List<String> extraCosts;

  Trip({
    required this.id,
    required this.fromLocation,
    required this.toLocation,
    required this.requestedPrice,
    required this.startTime,
    required this.biddingEndTime,
    required this.participantCount,
    this.vehicleType,
    this.notes,
    required this.status,
    this.bidPrice,
    this.selectedDriverId,
    this.selectedVehicleId,
    this.extraCosts = const [],
  });

  Trip copyWith({
    String? id,
    String? fromLocation,
    String? toLocation,
    double? requestedPrice,
    DateTime? startTime,
    DateTime? biddingEndTime,
    int? participantCount,
    String? vehicleType,
    String? notes,
    TripStatus? status,
    double? bidPrice,
    String? selectedDriverId,
    String? selectedVehicleId,
    List<String>? extraCosts,
  }) {
    return Trip(
      id: id ?? this.id,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
      requestedPrice: requestedPrice ?? this.requestedPrice,
      startTime: startTime ?? this.startTime,
      biddingEndTime: biddingEndTime ?? this.biddingEndTime,
      participantCount: participantCount ?? this.participantCount,
      vehicleType: vehicleType ?? this.vehicleType,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      bidPrice: bidPrice ?? this.bidPrice,
      selectedDriverId: selectedDriverId ?? this.selectedDriverId,
      selectedVehicleId: selectedVehicleId ?? this.selectedVehicleId,
      extraCosts: extraCosts ?? this.extraCosts,
    );
  }
}

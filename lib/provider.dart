import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model.dart';
import 'network.dart';

final videoListProvider = FutureProvider.autoDispose
    .family((_, PaginationModel pagination) => getAirPlane(pagination));

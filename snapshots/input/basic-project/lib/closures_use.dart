import 'closures.dart';

// Named arguments to stored closures from another file resolve to the
// closures' own parameters.
int useClosures() =>
    stored(body: 1) + Holder().cb(body: 2) + partStored(body: 3);

import 'package:bloc/bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:word_game/core/services/ad_service.dart';

class BannerAdCubit extends Cubit<BannerAd?> {
  BannerAdCubit(this._adService) : super(null) {
    _adService.createBannerAd(onLoaded: (ad) {
      if (!isClosed) emit(ad);
    });
  }

  final AdService _adService;

  @override
  Future<void> close() {
    state?.dispose();
    return super.close();
  }
}

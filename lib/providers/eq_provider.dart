import 'package:flutter/material.dart';

class EqProvider extends ChangeNotifier {
  // 10 bandas: Preamp + 31,62,125,250,500,1K,2K,4K,8K
  List<double> bands = List.filled(10, 0.0);
  double tone = 0.0;
  double treble = 0.0;
  double balance = 0.0;
  double stereoExpansion = 0.0;
  double volume = 0.44;
  double tempo = 1.0;
  double reverb = 0.0;
  double reverbMix = 0.0;
  double reverbSize = 0.0;
  double damping = 0.0;
  double filter = 0.0;
  double fade = 0.0;
  double preDelay = 0.0;
  double mixed = 0.0;
  bool mono = false;
  String preset = 'DVC EQ 10 TON LMT';

  static const bandLabels = ['Preamp','31','62','125','250','500','1K','2K','4K','8K'];

  static const presets = {
    'Flat':        [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],
    'Bass Boost':  [0.0,6.0,5.0,4.0,2.0,0.0,0.0,0.0,0.0,0.0],
    'Rock':        [0.0,4.0,3.0,2.0,0.0,-1.0,0.0,2.0,3.0,4.0],
    'Pop':         [0.0,-1.0,2.0,4.0,4.0,2.0,0.0,-1.0,0.0,1.0],
    'Jazz':        [0.0,3.0,2.0,1.0,2.0,-1.0,-1.0,0.0,1.0,2.0],
    'Classical':   [0.0,4.0,3.0,2.0,1.0,-1.0,-1.0,0.0,2.0,3.0],
    'Electronic':  [0.0,5.0,4.0,1.0,0.0,-1.0,2.0,2.0,3.0,4.0],
    'Vocal':       [0.0,-2.0,-1.0,0.0,3.0,4.0,3.0,2.0,1.0,0.0],
  };

  void setBand(int i, double v) {
    bands[i] = v.clamp(-12.0, 12.0);
    preset = 'Custom';
    notifyListeners();
  }

  void applyPreset(String name) {
    if (presets.containsKey(name)) {
      bands = List.from(presets[name]!);
      preset = name;
      notifyListeners();
    }
  }

  void setVolume(double v) { volume = v.clamp(0.0, 1.0); notifyListeners(); }
  void setBalance(double v) { balance = v.clamp(-1.0, 1.0); notifyListeners(); }
  void setStereoExpansion(double v) { stereoExpansion = v.clamp(0.0, 1.0); notifyListeners(); }
  void setTempo(double v) { tempo = v.clamp(0.5, 2.0); notifyListeners(); }
  void toggleMono() { mono = !mono; notifyListeners(); }
  void setReverb(double v) { reverb = v.clamp(0.0, 1.0); notifyListeners(); }
  void setReverbMix(double v) { reverbMix = v.clamp(0.0, 1.0); notifyListeners(); }
  void setReverbSize(double v) { reverbSize = v.clamp(0.0, 1.0); notifyListeners(); }
  void setDamping(double v) { damping = v.clamp(0.0, 1.0); notifyListeners(); }
  void setFilter(double v) { filter = v.clamp(0.0, 1.0); notifyListeners(); }
  void setFade(double v) { fade = v.clamp(0.0, 1.0); notifyListeners(); }
  void setPreDelay(double v) { preDelay = v.clamp(0.0, 1.0); notifyListeners(); }
  void setMixed(double v) { mixed = v.clamp(0.0, 1.0); notifyListeners(); }
  void reset() {
    bands = List.filled(10, 0.0);
    tone = 0.0; treble = 0.0; balance = 0.0; stereoExpansion = 0.0;
    volume = 1.0; tempo = 1.0; mono = false;
    reverb = 0.0; reverbMix = 0.0; reverbSize = 0.0;
    damping = 0.0; filter = 0.0; fade = 0.0; preDelay = 0.0; mixed = 0.0;
    preset = 'Flat';
    notifyListeners();
  }
}

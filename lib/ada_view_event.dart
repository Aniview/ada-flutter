sealed class AdaViewEvent {
  const AdaViewEvent();
}

class OnControllerAttachedEvent extends AdaViewEvent {
  const OnControllerAttachedEvent();
}

class OnAdLoadedEvent extends AdaViewEvent {
  const OnAdLoadedEvent();
}

class OnAdImpressionEvent extends AdaViewEvent {
  const OnAdImpressionEvent();
}

class OnAdCanRefreshEvent extends AdaViewEvent {
  const OnAdCanRefreshEvent();
}

class OnAdClickedEvent extends AdaViewEvent {
  const OnAdClickedEvent();
}

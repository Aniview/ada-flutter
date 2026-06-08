enum Profile {
  profileA(
    ProfileConfig(
      pubId: '647460657ee4d9368d0a56a4',
      tagId: '66751f45ea0f149e5c092fe6',
    ),
  ),

  prod(
    ProfileConfig(
      pubId: '687cd4217bcba04b0304a514',
      tagId: '68b8003e39658705dc0e968e',
    ),
  ),

  gam300x250(
    ProfileConfig(
      pubId: '565c56d3181f46bd608b459a',
      tagId: '681218808cd5289fd307e084',
    ),
  ),

  directBanner(
    ProfileConfig(
      pubId: '565c56d3181f46bd608b459a',
      tagId: '68b00e4a7c1583367d03f437',
    ),
  ),

  adMob(
    ProfileConfig(
      pubId: '565c56d3181f46bd608b459a',
      tagId: '689c3cb35bdaa4402808f206',
    ),
  ),

  dev4(
    ProfileConfig(
      pubId: '60fff8fbe80e7b248329d192',
      tagId: '66869bd1f9169753980c0c45',
      environment: 'wlgo1.dev4',
    ),
  );

  const Profile(this.config);

  final ProfileConfig config;
}

class ProfileConfig {
  final String environment;
  final String pubId;
  final String tagId;

  const ProfileConfig({
    this.environment = 'tg1',
    required this.pubId,
    required this.tagId,
  });
}

extension ProfileDisplay on Profile {
  String get title {
    switch (this) {
      case Profile.profileA:
        return 'Profile A';
      case Profile.prod:
        return 'Prod';
      case Profile.gam300x250:
        return 'GAM 300x250';
      case Profile.directBanner:
        return 'Direct Banner';
      case Profile.adMob:
        return 'AdMob';
      case Profile.dev4:
        return 'Dev4';
    }
  }
}
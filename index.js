import { NativeModules, NativeAppEventEmitter, Platform } from 'react-native'

const { RNAppleSignIn } = NativeModules

if (Platform.OS === 'android') {
  throw "No implementation for android"
}

export default {
  // performs authorization request, if you loged in previously - you may have already know the user dentificator (uid)	
  signIn: (uid, callback) => RNAppleSignIn.signIn(uid ? uid : '', callback),

  // listens for signin events with all the required details in response { uid, email, nick, givenName, familyName }
  onSignIn: (callback) => NativeAppEventEmitter.addListener('signin', callback),
}

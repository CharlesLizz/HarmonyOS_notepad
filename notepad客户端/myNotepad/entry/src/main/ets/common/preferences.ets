import { promptAction } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';


let context = getContext(this);
let preference: preferences.Preferences;
let preferenceTemp: preferences.Preferences;

/**
 * Preference model.
 *
 * @param fruitData Fruit data.
 */
class PreferenceModel {
   testToken: string = '';

  /**
   * Read the specified Preferences persistence file and load the data into the Preferences instance.
   */
  async getPreferencesFromStorage() {

      preference = await preferences.getPreferences(context, 'testToken.db');

  }

  /**
   * Deletes the specified Preferences persistence file from memory and removes the Preferences instance.
   */
  async deletePreferences() {

      await preferences.deletePreferences(context, 'testToken.db');


    preference = preferenceTemp;
    this.showToastMessage('删除数据库成功');
  }

  /**
   * Save the data to the Preferences.
   *
   * @param fruit Fruit data.
   */
  async putPreference(token:string) {
    if (!preference) {
      await this.getPreferencesFromStorage();
    }
    // The fruit name and fruit quantity data entered by the user are saved to the cached Preference instance.

      await preference.put('token', JSON.stringify(token));

    // Store the Preference instance in the preference persistence file
    await preference.flush();
  }

  /**
   * Get preference data.
   */
  async getPreference() {
    let token = '';
    if (!preference) {
      await this.getPreferencesFromStorage();
    }

      // fruit = <string> await preference.get(CommonConstants.KEY_NAME, '');
    token = (await preference.get('token', '')).toString();

    // If the data is empty, a message is displayed indicating that data needs to be written.
    if (token === '') {
      this.showToastMessage("数据为空，请先写入数据！");
      return;
    }
    this.showToastMessage("读取数据成功！");
    return JSON.parse(token);
  }

  /**
   * Process the data obtained from the database.
   */
  async getToken() {
    this.testToken = await this.getPreference();
    return this.testToken;
  }

  /**
   * Verifies that the data entered is not empty.
   *
   * @param fruit Fruit data.
   */
  checkFruitData(token:string) {
    if (token === '') {
      this.showToastMessage("token为空，请先输入数据！");
      return true;
    }
    return false;
  }

  /**
   * write data.
   *
   * @param fruit  Fruit data.
   */
  writeData(token:string) {
    // Check whether the data is null.
    let isDataNull = this.checkFruitData(token);
    if (isDataNull) {
      return;
    }
    // The data is inserted into the preferences database if it is not empty.
    this.putPreference(token);
    this.showToastMessage("写入数据成功！");
  }

  /**
   * Popup window prompt message.
   *
   * @param message Prompt message.
   */
  showToastMessage(message: string) {
    promptAction.showToast({
      message: message,
      duration: 3000
    });
  };
}

export default new PreferenceModel();
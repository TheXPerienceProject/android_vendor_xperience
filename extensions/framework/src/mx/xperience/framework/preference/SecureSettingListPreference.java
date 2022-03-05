/*
 * Copyright (C) 2017 AICP
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package mx.xperience.framework.preference;

import android.content.Context;
import androidx.preference.ListPreference;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.provider.Settings;

public class SecureSettingListPreference extends ListPreference {
    private boolean mAutoSummary = false;

    public SecureSettingListPreference(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setPreferenceDataStore(new SecureSettingsStore(context.getContentResolver()));
    }

    public SecureSettingListPreference(Context context, AttributeSet attrs) {
        super(context, attrs);
        setPreferenceDataStore(new SecureSettingsStore(context.getContentResolver()));
    }

    public SecureSettingListPreference(Context context) {
        super(context);
        setPreferenceDataStore(new SecureSettingsStore(context.getContentResolver()));
    }

    @Override
    public void setValue(String value) {
        super.setValue(value);
        if (mAutoSummary || TextUtils.isEmpty(getSummary())) {
            setSummary(getEntry(), true);
        }
    }

    @Override
    public void setSummary(CharSequence summary) {
        setSummary(summary, false);
    }

    private void setSummary(CharSequence summary, boolean autoSummary) {
        mAutoSummary = autoSummary;
        super.setSummary(summary);
    }

    private boolean isPersisted() {
        return Settings.Secure.getString(getContext().getContentResolver(), getKey()) != null;
    }

    private String getString(String key, String defaultValue) {
        String result = Settings.Secure.getString(getContext().getContentResolver(), key);
        return result == null ? defaultValue : result;
    }

    @Override
    protected void onSetInitialValue(boolean restorePersistedValue, Object defaultValue) {
        final String value;
        if (!restorePersistedValue || !isPersisted()) {
            if (defaultValue == null) {
                return;
            }
            value = (String) defaultValue;
            if (shouldPersist()) {
                persistString(value);
            }
        } else {
            // Note: the default is not used because to have got here
            // isPersisted() must be true.
            value = getString(getKey(), null /* not used */);
        }
        setValue(value);
    }

}

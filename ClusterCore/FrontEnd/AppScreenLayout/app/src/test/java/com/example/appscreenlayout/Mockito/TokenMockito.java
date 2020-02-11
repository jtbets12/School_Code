package com.example.appscreenlayout.Mockito;

import com.example.appscreenlayout.Screens.HubWorld;
import com.example.appscreenlayout.Screens.Login;
import com.example.appscreenlayout.Screens.Queue;

import org.json.JSONException;
import org.junit.Assert;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.mockito.Mockito.mock;
import static org.powermock.api.mockito.PowerMockito.mockStatic;

@RunWith(PowerMockRunner.class)
@PrepareForTest(Login.class)

public class TokenMockito {

    @Mock
    Login Token;

    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Test
    public void TokenSet_Test_HubWorld() throws JSONException {

        mockStatic(Login.class);
        HubWorld nameTest = new HubWorld();

        String username = "135896";

        PowerMockito.when(Login.grabToken()).thenReturn(username);

        Assert.assertEquals("135896", nameTest.getToken());
    }

    @Test
    public void LoginNameSet_TestFail() throws JSONException {

        mockStatic(Login.class);
        Queue nameTest = new Queue();

        String username = "15369";

        PowerMockito.when(Login.getVerifiedUser()).thenReturn(username);

        Assert.assertEquals("15389", nameTest.getToken());
    }

}

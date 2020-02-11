package com.example.appscreenlayout.Mockito;

import com.example.appscreenlayout.Screens.HubWorld;
import com.example.appscreenlayout.Screens.Login;

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

public class LoginMockito {


    @Mock
    Login VerifiedUser;

    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Test
    public void LoginNameSet_Test() throws JSONException {

        mockStatic(Login.class);
        HubWorld nameTest = new HubWorld();

        String username = "MinecraftSteve";

        PowerMockito.when(Login.getVerifiedUser()).thenReturn(username);

        Assert.assertEquals("MinecraftSteve", nameTest.getUser());
    }

    @Test
    public void LoginNameSet_TestFail() throws JSONException {

        mockStatic(Login.class);
        HubWorld nameTest = new HubWorld();

        String username = "MinecraftSteve";

        PowerMockito.when(Login.getVerifiedUser()).thenReturn(username);

        Assert.assertNotEquals(null, nameTest.getUser());
    }

}

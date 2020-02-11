package com.example.appscreenlayout.Mockito;

import com.example.appscreenlayout.Screens.Shop;

import org.json.JSONException;
import org.junit.Assert;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.mockito.Mockito.mock;
import static org.powermock.api.mockito.PowerMockito.mockStatic;

@RunWith(PowerMockRunner.class)
@PrepareForTest(Shop.class)
public class ShopMockiton {

    @Mock
    Shop balance;

    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Test
    public void balance_Test() throws JSONException {
        int testAmount = 500;
        Shop shop = new Shop();

        Mockito.mock(Shop.class);
        Mockito.when(Shop.getinitBalance()).thenReturn(testAmount);
        Assert.assertEquals(testAmount, shop.getBalance());
    }
}

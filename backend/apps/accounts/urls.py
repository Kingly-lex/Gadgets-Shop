from django.urls import path

from .views import (RegisterUserView, LoginView, LogoutView, ChangePassword,
                    ForgotPassword, SetNewPassword, PasswordResetConfirmWeb)

urlpatterns = [
    path('register/', RegisterUserView.as_view(), name='register'),

    path('login/', LoginView.as_view(), name='login'),

    path('change_password', ChangePassword.as_view(), name='change_password'),

    path('forgot_password', ForgotPassword.as_view(), name='forgot_password'),

    path('set_password', SetNewPassword.as_view(), name='set_password'),

    path('reset_confirm/<uidb64>/<token>', PasswordResetConfirmWeb.as_view(), name='reset_confirm'),

    path('logout/', LogoutView.as_view(), name='logout'),
]

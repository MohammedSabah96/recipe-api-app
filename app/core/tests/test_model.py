from django.test import TestCase
from django.contrib.auth import get_user_model


class ModelTests(TestCase):

    def test_create_user_with_email(self):
        email = 'test@test.com'
        password = 'passwordtest'
        user = get_user_model().objects.create_user(
            email=email,
            password=password
        )
        self.assertEqual(user.email, email)
        self.assertTrue(user.check_password(password))

    def test_new_user_email_normalized(self):
        email = 'test@TEST.com'
        user = get_user_model().objects.create_user(email, 'test2123')

        self.assertEqual(user.email, email.lower())

    def test_new_user_invalid_email(self):

        with self.assertRaises(ValueError):
            get_user_model().objects.create_user(None, 'taesd12')

    def test_create_superuser(self):
        user = get_user_model().objects.create_superuser(
            'test@test.com',
            'sdasf123'
        )
        self.assertTrue(user.is_staff)
        self.assertTrue(user.is_superuser)

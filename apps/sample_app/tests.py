from django.test import TestCase


class IsTests(TestCase):
    def is_logic_in_world_correct(self):
        self.assertEqual(1, 1)

import unittest
import azure.functions as func
from function_app import app

HANDLER=app.get_functions()[0].get_user_function()

class FunctionTests(unittest.TestCase):
    def call(self,body):
        handler=HANDLER
        return handler(func.HttpRequest(method='POST',url='https://example.invalid/api/validate',body=body))
    def test_valid_csv(self):
        self.assertEqual(self.call(b'id,value\na,10\n').status_code,200)
    def test_missing_schema(self):
        self.assertEqual(self.call(b'other\n10\n').status_code,400)
    def test_missing_value(self):
        self.assertEqual(self.call(b'id,value\na,\n').status_code,400)
    def test_invalid_encoding(self):
        self.assertEqual(self.call(b'\xff\xfe').status_code,400)

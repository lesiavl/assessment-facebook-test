import string
from random import choice
from os import path
from faker import Faker


def generate_fake_name():
    fake = Faker()
    full_name = fake.name()
    return full_name.split()


def format_string(resp_string):
    result = resp_string.split()
    return result[0]


def generate_string():
    random_string = ''.join([choice(string.ascii_letters + string.digits) for n in xrange(8)]) + '@srypto.net'
    return random_string


def hash_email(email):
    from hashlib import md5
    return md5(email).hexdigest()


def relative2absolute(relative_path):
    return path.abspath(relative_path)

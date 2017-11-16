import string
from random import choice
from os import path
from faker import Faker


def generate_fake_name():
    fake = Faker()
    full_name = fake.name()
    return full_name.split()


def generate_string():
    random_string = ''.join([choice(string.ascii_letters + string.digits) for n in xrange(8)])
    return random_string


def relative2absolute(relative_path):
    return path.abspath(relative_path)

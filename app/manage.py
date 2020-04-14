import click
from flask.cli import FlaskGroup

from app.app import create_app as createapp


def create_app(info):
    return createapp(cli=True)


@click.group(cls=FlaskGroup, create_app=create_app)
def cli():
    """Main entry point"""


@cli.command("init")
def init():
    from app.data import init
    init()

if __name__ == "__main__":
    cli()

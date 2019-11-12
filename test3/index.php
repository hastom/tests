<?php

class LongFileIterator implements SeekableIterator
{

	protected $handle;

	protected $position = 0;

	protected $path;

	public function __construct($path)
	{
		$this->path = $path;
	}

	protected function getHandle()
	{
		if (!$this->handle) {
			$this->handle = fopen($this->path, 'r');
		}
		return $this->handle;
	}

	protected function setPosition($position)
	{
		$this->position = $position;
		// фикс на случай если мы в 32битной системе
		if ($this->position > PHP_INT_MAX) {
			$offsets = $this->position % PHP_INT_MAX;
			for ($i = 0; $i < $offsets; $i++) {
				fseek($this->getHandle(), PHP_INT_MAX, SEEK_CUR);
			}
			fseek($this->getHandle(), (int)($this->position - ($offsets * PHP_INT_MAX)), SEEK_CUR);
		} else {
			fseek($this->getHandle(), $position);
		}
	}

	public function current()
	{
		return fgetc($this->getHandle());
	}

	public function next()
	{
		$this->setPosition($this->position + 1);
	}

	public function key()
	{
		return $this->position;
	}

	public function valid()
	{
		return !feof($this->getHandle());
	}

	public function rewind()
	{
		$this->setPosition(0);
	}

	public function seek($position)
	{
		if ($position < 0 || $position > filesize($this->path)) {
			throw new OutOfBoundsException();
		}
		$this->setPosition($position);
	}
}

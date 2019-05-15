from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
from django.utils import timezone
from microposts.models import Micropost, MicropostForm
from django.urls import reverse

# Create your views here.

def index(request):
	micropost_list = Micropost.objects.all()
	context = {'micropost_list': micropost_list}
	return render(request, 'microposts/index.html', context)


def new(request):
	return render(request, 'microposts/new.html')


def add(request):
	m1 = Micropost()
	m1.id = len(Micropost.objects.order_by('-id'))+1
	m = MicropostForm(request.POST, instance=m1)
	m.save()
	return HttpResponseRedirect(reverse('index'))


def detail(request, id):
	micropost = Micropost.objects.get(id=id)
	context = {'micropost': micropost}
	return render(request, 'microposts/new.html', context)


def update(request, id):
	m1 = Micropost.objects.get(id=id)
	m = MicropostForm(request.POST, instance=m1)
	m.save()
	return HttpResponseRedirect(reverse('index'))


def delete(request, id):
	m = Micropost.objects.get(id=id)
	m.delete()
	return HttpResponseRedirect(reverse('index'))




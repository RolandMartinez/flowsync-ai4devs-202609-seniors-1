import Task from '#models/task'
import User from '#models/user'
import { test } from '@japa/runner'
import testUtils from '@adonisjs/core/services/test_utils'

/**
 * Responsable de la tarea. Cubre los tres scenarios del requisito «Lo que cada
 * tarea muestra de su responsable» de `openspec/specs/tasks/spec.md`.
 */
test.group('Tasks | responsable', (group) => {
  group.each.setup(() => testUtils.db().withGlobalTransaction())

  async function tareaDe(fullName: string | null) {
    const user = await User.create({
      fullName,
      email: 'ada@example.com',
      password: 'secreto123',
    })

    const task = await Task.create({
      title: 'Revisar el informe',
      status: 'pending',
      assigneeId: user.id,
    })

    return { user, task }
  }

  async function sesion(client: any) {
    const response = await client
      .post('/api/v1/auth/login')
      .json({ email: 'ada@example.com', password: 'secreto123' })

    return response.body().data.token as string
  }

  test('una tarea trae el nombre y las iniciales de su responsable', async ({ client, assert }) => {
    const { task } = await tareaDe('Ada Lovelace')
    const token = await sesion(client)

    const response = await client
      .get(`/api/v1/tasks/${task.id}`)
      .qs({ today: '2026-10-05' })
      .header('Authorization', `Bearer ${token}`)

    response.assertStatus(200)

    const { assignee } = response.body().data
    assert.equal(assignee.fullName, 'Ada Lovelace')
    assert.equal(assignee.initials, 'AL')
  })

  test('el responsable no lleva el email ni otros datos de la cuenta, suelta o en la lista', async ({
    client,
    assert,
  }) => {
    const { task } = await tareaDe('Ada Lovelace')
    const token = await sesion(client)

    const suelta = await client
      .get(`/api/v1/tasks/${task.id}`)
      .qs({ today: '2026-10-05' })
      .header('Authorization', `Bearer ${token}`)

    const lista = await client.get('/api/v1/tasks').header('Authorization', `Bearer ${token}`)

    suelta.assertStatus(200)
    lista.assertStatus(200)

    const responsables = {
      suelta: suelta.body().data.assignee,
      lista: lista.body().data[0].assignee,
    }

    for (const [donde, assignee] of Object.entries(responsables)) {
      for (const dato of ['email', 'password', 'createdAt', 'updatedAt']) {
        assert.notProperty(assignee as object, dato, `${donde}: el assignee no debe llevar «${dato}»`)
      }
    }
  })

  test('un responsable sin nombre llega con el nombre nulo y con iniciales', async ({
    client,
    assert,
  }) => {
    const { task } = await tareaDe(null)
    const token = await sesion(client)

    const response = await client
      .get(`/api/v1/tasks/${task.id}`)
      .qs({ today: '2026-10-05' })
      .header('Authorization', `Bearer ${token}`)

    response.assertStatus(200)

    const { assignee } = response.body().data
    assert.isNull(assignee.fullName)
    assert.isString(assignee.initials)
    assert.isNotEmpty(assignee.initials)
  })
})

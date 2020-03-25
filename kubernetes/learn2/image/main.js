const k8s = require('@kubernetes/client-node');
const { Client } = require('pg')
const client = new Client(process.env.POSTGRES_URL)

const kc = new k8s.KubeConfig();
kc.loadFromDefault();

const k8sApi = kc.makeApiClient(k8s.CoreV1Api);
const namespace = 'default';

async function getPods(namespace) {
	const pods = await k8sApi.listNamespacedPod(namespace).then((res) => {
		const response = res.body.items.map(n => {
			return {
				name: n.metadata.name,
				selector: n.metadata.labels.app
			}
		})
	  return response;
	});

	const services = await k8sApi.listNamespacedService(namespace).then(({ body }) => {
		const items = body.items.map(n => {
			return {
				name: n.metadata.name,
				selector: (n.spec.selector || {}).app
			}
		}).filter(n => n.selector);

		let output = {};
		for (let item of items) {
			output[item.selector] = item.name;
		}
		return output;
	});

	return pods.map(pod => {
		return {
			service: services[pod.selector],
			pod: pod.name
		}
	}).filter(n => n.service);
}

let last = [];

async function run(client) {
	const updates = await getPods(namespace);
	if (JSON.stringify(updates) !== JSON.stringify(last)) {
		console.log('Updating pods');
		last = updates;
		await client.query('truncate kubernetes_pods');
		await client.query(`
			insert into kubernetes_pods (service, pod, timestamp)
			select *
			from unnest($1::text[], $2::text[], $3::timestamp[])`, [
			updates.map(n => n.service),
			updates.map(n => n.pod),
			updates.map(n => new Date().toISOString())
		]);
	}
	setTimeout(() => run(client), Number(process.env.TIMEOUT))
}

async function start() {
	await client.connect();
	await client.query(`SET SCHEMA '${process.env.SCHEMA}'`);
	run(client);
}

start();